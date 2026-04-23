package com.example.loudhotel.service;


import com.example.loudhotel.dto.request.ReviewRequest;
import com.example.loudhotel.dto.response.ReviewResponse;
import org.springframework.data.domain.Page;

import java.util.List;

public interface ReviewService {
    ReviewResponse updateReview(Long reviewId, ReviewRequest request);

    ReviewResponse createReview(Long hotelId, ReviewRequest request);

    List<ReviewResponse> getReviewsByHotel(Long hotelId);

    Page<ReviewResponse> getReviews(String keyword,
                                    Double rate,
                                    Double minRate,
                                    Double maxRate,
                                    String hotelStatus,
                                    int page,
                                    int size,
                                    String sortBy,
                                    String direction);

    void managerToggle(Long reviewId);

    void adminApproveHide(Long reviewId);

    Page<ReviewResponse> getReviewsByManager(
            String keyword,
            Double rate,
            Double minRate,
            Double maxRate,
            String hotelStatus,
            int page,
            int size,
            String sortBy,
            String direction
    );

    void adminRejectHide(Long reviewId);

    void adminShow(Long reviewId);

    void adminHide(Long reviewId);

}
