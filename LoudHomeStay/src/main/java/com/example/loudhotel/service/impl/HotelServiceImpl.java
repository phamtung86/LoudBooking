package com.example.loudhotel.service.impl;

import com.example.loudhotel.dto.request.HotelRequest;
import com.example.loudhotel.dto.response.HotelResponse;
import com.example.loudhotel.dto.response.ImageResponse;
import com.example.loudhotel.entity.Hotel;
import com.example.loudhotel.entity.HotelImage;
import com.example.loudhotel.entity.User;
import com.example.loudhotel.exception.BadRequestException;
import com.example.loudhotel.exception.ResourceNotFoundException;
import com.example.loudhotel.repository.HotelRepository;
import com.example.loudhotel.repository.RoomTypeRepository;
import com.example.loudhotel.repository.UserRepository;
import com.example.loudhotel.service.HotelService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class HotelServiceImpl implements HotelService {

    private final HotelRepository hotelRepository;
    private final UserRepository userRepository;
    private final RoomTypeRepository roomTypeRepository;

    private HotelResponse map(Hotel h) {
        h.setRoomsTotal(
                h.getRooms() != null ? h.getRooms().size() : 0
        );

        List<ImageResponse> images = List.of();
        String mainImage = null;

        if (h.getImages() != null && !h.getImages().isEmpty()) {

            images = h.getImages()
                    .stream()
                    .map(img -> {
                        ImageResponse r = new ImageResponse();
                        r.setImageId(img.getImageId());
                        r.setImageUrl(img.getImageUrl());
                        r.setMain(Boolean.TRUE.equals(img.getIsMain()));
                        return r;
                    })
                    .toList();

            mainImage = h.getImages()
                    .stream()
                    .filter(img -> Boolean.TRUE.equals(img.getIsMain()))
                    .map(HotelImage::getImageUrl)
                    .findFirst()
                    .orElse(images.isEmpty() ? null : images.get(0).getImageUrl());
        }

        return HotelResponse.builder()
                .hotelId(h.getHotelId())
                .hotelName(h.getHotelName())
                .address(h.getAddress())
                .introduction(h.getIntroduction())
                .averageRating(h.getAverageRating())
                .roomsTotal(h.getRoomsTotal())
                .hotelStatus(h.getHotelStatus())
                .managerEmail(
                        h.getManager() != null
                                ? h.getManager().getEmail()
                                : null
                ) // thêm
                .managerFullName(
                        h.getManager() != null
                                ? (h.getManager().getFirstName() == null ? "" : h.getManager().getFirstName()) +
                                " " +
                                (h.getManager().getLastName() == null ? "" : h.getManager().getLastName())
                                : null
                )
                .createdAt(h.getCreatedAt())
                .updatedAt(h.getUpdatedAt())
                .mainImage(mainImage)
                .images(images)
                .build();
    }

    @Override
    public List<HotelResponse> getMyHotels(){

        String email =
                SecurityContextHolder.getContext()
                        .getAuthentication()
                        .getName();

        User manager =
                userRepository
                        .findByEmailAndIsDeletedFalse(email)
                        .orElseThrow();

        return hotelRepository
                .findByManager_UserIdAndIsDeletedFalse(manager.getUserId())
                .stream()
                .map(this::map)
                .toList();
    }

    @Override
    public HotelResponse createHotel(HotelRequest request) {

        if (request.getManagerId() == null) {
            throw new RuntimeException("Phải chọn manager");
        }

        User manager = userRepository
                .findById(request.getManagerId())
                .orElseThrow(() -> new ResourceNotFoundException("Manager không tồn tại"));

        // ✅ check role
        if (manager.getRole() != User.Role.MANAGER) {
            throw new RuntimeException("User này không phải MANAGER");
        }

        // ✅ (khuyến nghị) 1 manager chỉ 1 hotel
        if (hotelRepository.existsByManager_UserIdAndIsDeletedFalse(manager.getUserId())) {
            throw new BadRequestException("Manager này đã có khách sạn");
        }

        Hotel hotel = Hotel.builder()
                .hotelName(request.getHotelName())
                .address(request.getAddress())
                .introduction(request.getIntroduction())
                .hotelStatus(request.getHotelStatus())
                .manager(manager)
                .isDeleted(false)
                .build();

        hotelRepository.save(hotel);

        return map(hotel);
    }

    @Override
    public HotelResponse getHotelById(Long id) {
        return map(
                hotelRepository
                        .findByHotelIdAndIsDeletedFalse(id)
                        .orElseThrow(() -> new ResourceNotFoundException("Hotel không tồn tại"))
        );
    }

    @Override
    public List<HotelResponse> getAll() {
        return hotelRepository.findAllWithImages()
                .stream()
                .map(this::map)
                .toList();
    }

    @Override
    public List<HotelResponse> searchAll(String keyword) {

        return hotelRepository
                .searchAll(keyword)
                .stream()
                .map(this::map)
                .toList();
    }

    @Override
    public void deleteHotel(Long id) {

        Hotel hotel = hotelRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Hotel không tồn tại"));

        String email =
                SecurityContextHolder.getContext()
                        .getAuthentication()
                        .getName();

        User currentUser =
                userRepository.findByEmailAndIsDeletedFalse(email)
                        .orElseThrow();

        boolean isAdmin =
                currentUser.getRole() == User.Role.ADMIN;

        boolean isManager =
                hotel.getManager() != null &&
                hotel.getManager().getUserId()
                        .equals(currentUser.getUserId());

        if(!isAdmin && !isManager){
            throw new RuntimeException(
                    "Không có quyền xóa hotel này"
            );
        }

        if (roomTypeRepository.existsByHotel_HotelIdAndIsDeletedFalse(id)) {
            throw new RuntimeException("Không thể xóa khách sạn khi còn loại phòng");
        }

        hotel.setIsDeleted(true);

        hotelRepository.save(hotel);
    }

    @Override
    public HotelResponse updateHotel(Long id, HotelRequest request) {

        Hotel hotel = hotelRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Hotel không tồn tại"));

        String email =
                SecurityContextHolder.getContext()
                        .getAuthentication()
                        .getName();

        User currentUser =
                userRepository.findByEmailAndIsDeletedFalse(email)
                        .orElseThrow();

        boolean isAdmin =
                currentUser.getRole() == User.Role.ADMIN;

        boolean isManager =
                hotel.getManager() != null &&
                hotel.getManager().getUserId()
                        .equals(currentUser.getUserId());

        if(!isAdmin && !isManager){
            throw new RuntimeException(
                    "Không có quyền sửa hotel này"
            );
        }
        if (isAdmin && request.getManagerId() != null) {

            User newManager = userRepository.findById(request.getManagerId())
                    .orElseThrow(() -> new ResourceNotFoundException("Manager không tồn tại"));

            if (newManager.getRole() != User.Role.MANAGER) {
                throw new RuntimeException("User không phải MANAGER");
            }

            hotel.setManager(newManager);
        }

        hotel.setHotelName(request.getHotelName());
        hotel.setAddress(request.getAddress());
        hotel.setIntroduction(request.getIntroduction());
        if (isAdmin) {
            hotel.setHotelStatus(request.getHotelStatus());
        } else {
            // Manager không được khóa

            hotel.setHotelStatus(request.getHotelStatus());
        }

        hotelRepository.save(hotel);

        return map(hotel);
    }

}
