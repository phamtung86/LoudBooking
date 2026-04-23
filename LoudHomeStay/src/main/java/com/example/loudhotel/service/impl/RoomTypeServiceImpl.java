package com.example.loudhotel.service.impl;

import com.example.loudhotel.dto.request.RoomTypeRequest;
import com.example.loudhotel.dto.response.ImageResponse;
import com.example.loudhotel.dto.response.RoomTypeResponse;
import com.example.loudhotel.entity.Hotel;
import com.example.loudhotel.entity.RoomType;
import com.example.loudhotel.entity.RoomTypeImage;
import com.example.loudhotel.repository.HotelRepository;
import com.example.loudhotel.repository.RoomRepository;
import com.example.loudhotel.repository.RoomTypeRepository;
import com.example.loudhotel.service.RoomTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RoomTypeServiceImpl implements RoomTypeService {

    private final RoomTypeRepository roomTypeRepository;
    private final HotelRepository hotelRepository;
    private final RoomRepository roomRepository;

    private RoomTypeResponse map(RoomType rt) {

        List<ImageResponse> images = List.of();
        String mainImage = null;

        if (rt.getImages() != null && !rt.getImages().isEmpty()) {

            images = rt.getImages().stream().map(img -> {
                ImageResponse r = new ImageResponse();
                r.setImageId(img.getImageId());
                r.setImageUrl(img.getImageUrl());
                r.setMain(Boolean.TRUE.equals(img.getIsMain()));
                return r;
            }).toList();

            mainImage = rt.getImages().stream()
                    .filter(img -> Boolean.TRUE.equals(img.getIsMain()))
                    .map(img -> img.getImageUrl())
                    .findFirst()
                    .orElse(images.isEmpty() ? null : images.get(0).getImageUrl());
        }

        return RoomTypeResponse.builder()
                .typeId(rt.getTypeId())
                .typeName(rt.getTypeName())
                .capacity(rt.getCapacity())
                .price(rt.getPrice())
                .description(rt.getDescription())
                .bedType(rt.getBedType().name())
                .bedCount(rt.getBedCount())
                .area(rt.getArea())
                .hotelId(rt.getHotel().getHotelId())
                .hotelStatus(rt.getHotel().getHotelStatus().name())
                .hotelName(rt.getHotel().getHotelName())
                .createdAt(rt.getCreatedAt())
                .updatedAt(rt.getUpdatedAt())
                .mainImage(mainImage)
                .images(images)
                .build();
    }

    @Override
    public List<RoomTypeResponse> getAll() {
        return roomTypeRepository.findByIsDeletedFalse()
                .stream()
                .map(this::map)
                .toList();
    }

    @Override
    public RoomTypeResponse create(Long hotelId, RoomTypeRequest request) {

        Hotel hotel = hotelRepository.findById(hotelId)
                .orElseThrow(() -> new RuntimeException("Hotel not found"));

        boolean exists = roomTypeRepository
                .existsByHotel_HotelIdAndTypeNameAndIsDeletedFalse(
                        hotelId,
                        request.getTypeName()
                );

        if (exists) {
            throw new RuntimeException("Tên loại phòng đã tồn tại trong khách sạn này");
        }

        RoomType roomType = RoomType.builder()
                .typeName(request.getTypeName())
                .capacity(request.getCapacity())
                .price(request.getPrice())
                .description(request.getDescription())
                .bedType(RoomType.BedType.valueOf(request.getBedType()))
                .bedCount(request.getBedCount())
                .area(request.getArea())
                .hotel(hotel)
                .isDeleted(false)
                .build();

        return map(roomTypeRepository.save(roomType));
    }

    @Override
    public RoomTypeResponse update(Long id, RoomTypeRequest request) {

        RoomType rt = roomTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("RoomType not found"));

        boolean exists = roomTypeRepository
                .existsByHotel_HotelIdAndTypeNameAndIsDeletedFalse(
                        rt.getHotel().getHotelId(),
                        request.getTypeName()
                );

        // tránh check chính nó
        if (exists && !rt.getTypeName().equals(request.getTypeName())) {
            throw new RuntimeException("Tên loại phòng đã tồn tại trong khách sạn này");
        }

        rt.setTypeName(request.getTypeName());
        rt.setCapacity(request.getCapacity());
        rt.setPrice(request.getPrice());
        rt.setDescription(request.getDescription());
        rt.setBedType(RoomType.BedType.valueOf(request.getBedType()));
        rt.setBedCount(request.getBedCount());
        rt.setArea(request.getArea());

        return map(roomTypeRepository.save(rt));
    }

    @Override
    public void delete(Long id) {

        RoomType rt = roomTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("RoomType not found"));

        // ❗ CHECK QUAN TRỌNG
        boolean hasRooms = roomRepository
                .existsByRoomType_TypeIdAndIsDeletedFalse(id);

        if (hasRooms) {
            throw new RuntimeException("Không thể xóa loại phòng đang có phòng");
        }

        rt.setIsDeleted(true);
        roomTypeRepository.save(rt);
    }

    @Override
    public List<RoomTypeResponse> getByHotel(Long hotelId) {

        return roomTypeRepository
                .findByHotel_HotelIdAndIsDeletedFalse(hotelId)
                .stream()
                .map(this::map)
                .toList();
    }

    @Override
    public RoomTypeResponse getById(Long id) {

        RoomType rt = roomTypeRepository
                .findByTypeIdAndIsDeletedFalse(id)
                .orElseThrow(() -> new RuntimeException("RoomType not found"));

        return map(rt);
    }

    @Override
    public List<RoomTypeResponse> getRoomTypesByManager(Long managerId) {

        return roomTypeRepository.findAll()
                .stream()
                .filter(rt -> !rt.getIsDeleted())
                .filter(rt -> rt.getHotel() != null)
                .filter(rt -> rt.getHotel().getManager() != null) // 👈 FIX
                .filter(rt -> rt.getHotel().getManager().getUserId().equals(managerId))
                .map(this::map)
                .toList();
    }
}