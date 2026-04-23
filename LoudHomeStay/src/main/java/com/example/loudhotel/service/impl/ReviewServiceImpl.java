package com.example.loudhotel.service.impl;

import com.example.loudhotel.dto.request.ReviewRequest;
import com.example.loudhotel.dto.response.ReviewResponse;
import com.example.loudhotel.entity.Hotel;
import com.example.loudhotel.entity.Review;
import com.example.loudhotel.entity.User;
import com.example.loudhotel.exception.ResourceNotFoundException;
import com.example.loudhotel.repository.HotelRepository;
import com.example.loudhotel.repository.ReviewRepository;
import com.example.loudhotel.repository.UserRepository;
import com.example.loudhotel.service.ReviewService;
import com.example.loudhotel.utils.SecurityUtil;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewRepository reviewRepository;
    private final HotelRepository hotelRepository;
    private final UserRepository userRepository;

    private ReviewResponse mapToResponse(Review review) {
        Long currentUserId = null;
        try {
            currentUserId = SecurityUtil.getCurrentUserId();
        } catch (Exception ignored) {}

        return ReviewResponse.builder()
                .reviewId(review.getReviewId())
                .username(review.getUser() != null ? review.getUser().getUsername() : null)
                .hotelName(review.getHotel().getHotelName())
                .rate(review.getRate())
                .comment(review.getComment())
                .createdAt(review.getCreatedAt())
                .status(review.getStatus() != null ? review.getStatus().name() : null)
                .hotelStatus(review.getHotel().getHotelStatus().name())
                .isMine(
                        currentUserId != null &&
                                review.getUser().getUserId().equals(currentUserId)
                )
                .build();
    }

    private void updateAvg(Long hotelId) {
        List<Review> reviews = reviewRepository.findByHotel_HotelId(hotelId)
                .stream()
                .filter(r -> r.getStatus() == Review.ReviewStatus.ACTIVE)
                .toList();

        double avg = reviews.stream()
                .mapToDouble(Review::getRate)
                .average()
                .orElse(0);

        Hotel hotel = hotelRepository.findById(hotelId).orElseThrow();
        hotel.setAverageRating(avg);
        hotelRepository.save(hotel);
    }

    @Override
    public ReviewResponse createReview(Long hotelId, ReviewRequest request) {

        Long userId = SecurityUtil.getCurrentUserId();

        Review existing = reviewRepository
                .findByUser_UserIdAndHotel_HotelId(userId, hotelId)
                .orElse(null);

        if (existing != null) {
            throw new RuntimeException("Bạn đã đánh giá rồi, hãy chỉnh sửa");
        }

        User user = userRepository.findById(userId).orElseThrow();
        Hotel hotel = hotelRepository.findById(hotelId).orElseThrow();

        Review review = Review.builder()
                .user(user)
                .hotel(hotel)
                .rate(request.getRate())
                .comment(request.getComment())
                .status(Review.ReviewStatus.ACTIVE)
                .build();

        reviewRepository.save(review);

        updateAvg(hotelId);

        return mapToResponse(review);
    }
    @Override
    public List<ReviewResponse> getReviewsByHotel(Long hotelId) {

        Long currentUserId = null;

        try {
            currentUserId = SecurityUtil.getCurrentUserId();
        } catch (Exception e) {
            // chưa login
        }

        Long finalCurrentUserId = currentUserId;

        return reviewRepository.findByHotel_HotelId(hotelId)
                .stream()
                .filter(r ->
                        r.getStatus() == Review.ReviewStatus.ACTIVE
                                || (finalCurrentUserId != null
                                && r.getUser().getUserId().equals(finalCurrentUserId))
                )
                .map(this::mapToResponse)
                .toList();
    }

    @Override
    public ReviewResponse updateReview(Long reviewId, ReviewRequest request) {

        Long userId = SecurityUtil.getCurrentUserId();

        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new ResourceNotFoundException("Review not found"));

        // 🔥 chỉ chính chủ được sửa
        if (!review.getUser().getUserId().equals(userId)) {
            throw new RuntimeException("Không có quyền sửa");
        }

        // ✅ cho sửa cả ACTIVE và HIDDEN
        review.setRate(request.getRate());
        review.setComment(request.getComment());

        reviewRepository.save(review);

        updateAvg(review.getHotel().getHotelId());

        return mapToResponse(review);
    }



    @Override
    public Page<ReviewResponse> getReviews(String keyword,
                                           Double rate,
                                           Double minRate,
                                           Double maxRate,
                                           String hotelStatus,
                                           int page,
                                           int size,
                                           String sortBy,
                                           String direction) {

        Long userId = null;
        String role = null;

        try {
            userId = SecurityUtil.getCurrentUserId();
            role = SecurityContextHolder.getContext().getAuthentication()
                    .getAuthorities().iterator().next().getAuthority();
        } catch (Exception ignored) {}

        Sort sort = direction.equalsIgnoreCase("desc")
                ? Sort.by(sortBy).descending()
                : Sort.by(sortBy).ascending();

        Pageable pageable = PageRequest.of(page, size, sort);

        Hotel.HotelStatus statusEnum = null;
        if (hotelStatus != null && !hotelStatus.isEmpty()) {
            try {
                statusEnum = Hotel.HotelStatus.valueOf(hotelStatus.toUpperCase());
            } catch (Exception ignored) {}
        }

        Page<Review> reviewPage;

        // ADMIN
        if ("ROLE_ADMIN".equals(role)) {
            reviewPage = reviewRepository.searchReviews(
                    keyword, rate, minRate, maxRate, statusEnum, pageable
            );
        }
        // Manager
        else {
            reviewPage = reviewRepository.searchReviewsByManager(
                    userId, keyword, rate, minRate, maxRate, statusEnum, pageable
            );
        }

        return reviewPage.map(this::mapToResponse);
    }

    @Override
    @Transactional
    public void managerToggle(Long reviewId) {

        Long managerId = SecurityUtil.getCurrentUserId();

        Review review = reviewRepository
                .findByIdAndManagerId(reviewId, managerId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Review không thuộc khách sạn của bạn")
                );

        if (review.getStatus() == Review.ReviewStatus.ACTIVE) {
            // 👉 manager yêu cầu ẩn → chờ admin duyệt
            review.setStatus(Review.ReviewStatus.PENDING_HIDE);

        } else if (review.getStatus() == Review.ReviewStatus.HIDDEN) {
            // 👉 hiện lại luôn (không cần admin)
            review.setStatus(Review.ReviewStatus.ACTIVE);

        } else {
            // 👉 đang PENDING thì KHÔNG cho bấm
            throw new RuntimeException("Đang chờ admin duyệt");
        }

        reviewRepository.save(review);
    }

    @Transactional
    @Override
    public void adminApproveHide(Long reviewId) {

        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new ResourceNotFoundException("Review not found"));

        if (review.getStatus() != Review.ReviewStatus.PENDING_HIDE) {
            throw new RuntimeException("Không phải trạng thái chờ duyệt");
        }

        review.setStatus(Review.ReviewStatus.HIDDEN);

        reviewRepository.save(review);

        updateAvg(review.getHotel().getHotelId());
    }

    @Override
    public Page<ReviewResponse> getReviewsByManager(String keyword,
                                                  Double rate,
                                                  Double minRate,
                                                  Double maxRate,
                                                  String hotelStatus,
                                                  int page,
                                                  int size,
                                                  String sortBy,
                                                  String direction) {

        Long managerId = SecurityUtil.getCurrentUserId();

        Sort sort = direction.equalsIgnoreCase("desc")
                ? Sort.by(sortBy).descending()
                : Sort.by(sortBy).ascending();

        Pageable pageable = PageRequest.of(page, size, sort);

        Hotel.HotelStatus statusEnum = null;

        if (hotelStatus != null && !hotelStatus.isEmpty()) {
            try {
                statusEnum = Hotel.HotelStatus.valueOf(hotelStatus.toUpperCase());
            } catch (Exception e) {
                statusEnum = null;
            }
        }

        Page<Review> reviewPage = reviewRepository.searchReviewsByManager(
                managerId,
                keyword,
                rate,
                minRate,
                maxRate,
                statusEnum,
                pageable
        );

        return reviewPage.map(this::mapToResponse);
    }

    @Transactional
    public void adminRejectHide(Long reviewId) {

        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new ResourceNotFoundException("Review not found"));

        if (review.getStatus() == Review.ReviewStatus.PENDING_HIDE) {
            review.setStatus(Review.ReviewStatus.ACTIVE);
            reviewRepository.save(review);
        }
    }

    @Transactional
    public void adminShow(Long reviewId) {

        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new ResourceNotFoundException("Review not found"));

        review.setStatus(Review.ReviewStatus.ACTIVE);

        reviewRepository.save(review);

        updateAvg(review.getHotel().getHotelId());
    }

    @Transactional
    public void adminHide(Long reviewId) {

        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new ResourceNotFoundException("Review not found"));

        review.setStatus(Review.ReviewStatus.HIDDEN);

        reviewRepository.save(review);

        updateAvg(review.getHotel().getHotelId());
    }
}
