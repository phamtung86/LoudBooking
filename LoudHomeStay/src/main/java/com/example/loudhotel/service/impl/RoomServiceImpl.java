package com.example.loudhotel.service.impl;

import com.example.loudhotel.dto.request.RoomRequest;
import com.example.loudhotel.dto.response.ImageResponse;
import com.example.loudhotel.dto.response.RoomResponse;
import com.example.loudhotel.entity.Hotel;
import com.example.loudhotel.entity.Room;
import com.example.loudhotel.entity.RoomType;
import com.example.loudhotel.entity.User;
import com.example.loudhotel.exception.BadRequestException;
import com.example.loudhotel.exception.ResourceNotFoundException;
import com.example.loudhotel.repository.*;
import com.example.loudhotel.service.RoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class RoomServiceImpl implements RoomService {

    private final RoomRepository roomRepository;
    private final HotelRepository hotelRepository;
    private final BillRepository billRepository;
    // ng dùng htai
    private final UserRepository userRepository;
    private final RoomTypeRepository roomTypeRepository;

    private User getCurrentUser() {

        Authentication authentication = SecurityContextHolder
                .getContext()
                .getAuthentication();

        String email = authentication.getName();

        return userRepository
                .findByEmailAndIsDeletedFalse(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    private void validateHotelActive(Hotel hotel) {
        if (hotel.getHotelStatus() == Hotel.HotelStatus.INACTIVE) {

            throw new BadRequestException("Khách sạn ngừng hoạt động!");
        }
    }

    private RoomResponse map(Room room) {

        List<ImageResponse> images = List.of();
        String mainImage = null;

        if (room.getRoomType().getImages() != null && !room.getRoomType().getImages().isEmpty()) {

            images = room.getRoomType().getImages()
                    .stream()
                    .map(img -> {
                        ImageResponse r = new ImageResponse();
                        r.setImageId(img.getImageId());
                        r.setImageUrl(img.getImageUrl());
                        r.setMain(Boolean.TRUE.equals(img.getIsMain()));
                        return r;
                    })
                    .toList();

            mainImage = room.getRoomType().getImages()
                    .stream()
                    .filter(img -> Boolean.TRUE.equals(img.getIsMain()))
                    .map(img -> img.getImageUrl())
                    .findFirst()
                    .orElse(images.isEmpty() ? null : images.get(0).getImageUrl());
        }

        return RoomResponse.builder()
                .roomId(room.getRoomId())
                .roomNumber(room.getRoomNumber())
                .roomStatus(room.getRoomStatus())
                .roomTypeId(room.getRoomType().getTypeId())
                .roomTypeName(room.getRoomType().getTypeName())
                .capacity(room.getRoomType().getCapacity())
                .price(room.getRoomType().getPrice())
                .bedType(room.getRoomType().getBedType().name())
                .bedCount(room.getRoomType().getBedCount())
                .area(room.getRoomType().getArea())
                .createdAt(room.getCreatedAt())
                .updatedAt(room.getUpdatedAt())
                .hotelId(room.getHotel().getHotelId())
                .hotelStatus(room.getHotel().getHotelStatus().name())
                .images(images)
                .mainImage(mainImage)
                .build();
    }

    @Override
    public List<RoomResponse> getAllRooms() {

        return roomRepository.findAllActiveRooms()
                .stream()
                .map(this::map)
                .toList();
    }

    @Override
    public RoomResponse create(Long hotelId, RoomRequest request) {

        Hotel hotel = hotelRepository
                .findByHotelIdAndIsDeletedFalse(hotelId)
                .orElseThrow(() -> new ResourceNotFoundException("Hotel not found"));

        validateHotelActive(hotel);

        User currentUser = getCurrentUser();

        boolean isAdmin = currentUser.getRole().name().equals("ADMIN");

        boolean isManager = hotel.getManager().getUserId()
                .equals(currentUser.getUserId());

        if(!isAdmin && !isManager){
            throw new RuntimeException("Không có quyền thêm room vào hotel này");
        }

        if (roomRepository.existsByHotelAndRoomNumberAndIsDeletedFalse(
                hotel, request.getRoomNumber())) {
            throw new BadRequestException("Số phòng đã tồn tại trong khách sạn");
        }

        RoomType roomType = roomTypeRepository.findById(request.getRoomTypeId())
                .orElseThrow(() -> new RuntimeException("Room type not found"));

        Room room = Room.builder()
                .roomType(roomType)
                .roomNumber(request.getRoomNumber())
                .roomStatus(request.getRoomStatus())
                .hotel(hotel)
                .isDeleted(false)
                .build();

        Room savedRoom = roomRepository.save(room);

        /* UPDATE ROOM TOTAL */

        long totalRooms = roomRepository.countByHotelAndIsDeletedFalse(hotel);

        hotel.setRoomsTotal((int) totalRooms);

        hotelRepository.save(hotel);

        return map(savedRoom);
    }

    @Override
    public List<RoomResponse> getByHotel(Long hotelId) {

        Hotel hotel = hotelRepository
                .findByHotelIdAndIsDeletedFalse(hotelId)
                .orElseThrow(() -> new ResourceNotFoundException("Hotel not found"));

        return roomRepository.findActiveByHotel(hotel)
                .stream()
                .map(this::map)
                .toList();
    }

    @Override
    public void deleteRoom(Long roomId) {

        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new ResourceNotFoundException("Room not found"));

        User currentUser = getCurrentUser();

        boolean isAdmin = currentUser.getRole().name().equals("ADMIN");

        boolean isManager = room.getHotel().getManager().getUserId()
                .equals(currentUser.getUserId());

        if(!isAdmin && !isManager){
            throw new RuntimeException("Không có quyền xoá room");
        }
        room.setIsDeleted(true);
        roomRepository.save(room);

        Hotel hotel = room.getHotel();

        long totalRooms = roomRepository
                .countByHotelAndIsDeletedFalse(hotel);

        hotel.setRoomsTotal((int) totalRooms);

        hotelRepository.save(hotel);
    }

    @Override
    public RoomResponse getRoomById(Long id) {

        Room room = roomRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Room not found"));

        return map(room);
    }

    @Override
    public RoomResponse update(Long id, RoomRequest request) {

        Room room = roomRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Room not found"));

        Hotel hotel = room.getHotel();

        User currentUser = getCurrentUser();

        boolean isAdmin = currentUser.getRole().name().equals("ADMIN");

        boolean isManager = hotel.getManager().getUserId()
                .equals(currentUser.getUserId());

        // ADMIN được toàn quyền
        if (!isAdmin) {

            // Manager phải đúng hotel
            if (!isManager) {
                throw new RuntimeException("Không có quyền sửa room");
            }

            // Manager mới bị check hotel active
            validateHotelActive(hotel);


        }

        if (!room.getRoomNumber().equals(request.getRoomNumber()) &&
                roomRepository.existsByHotelAndRoomNumberAndIsDeletedFalse(
                        hotel, request.getRoomNumber())) {

            throw new BadRequestException("Số phòng đã tồn tại trong khách sạn");
        }
        RoomType roomType = roomTypeRepository.findById(request.getRoomTypeId())
                .orElseThrow(() -> new RuntimeException("Room type not found"));

        room.setRoomType(roomType);

        room.setRoomNumber(request.getRoomNumber());
        room.setRoomType(roomType);
        room.setRoomStatus(request.getRoomStatus());

        roomRepository.save(room);

        return map(room);
    }

    @Override
    public List<RoomResponse> getAvailableRooms(
            Long hotelId,
            LocalDate checkIn,
            LocalDate checkOut,
            Integer guest
    ) {
        Hotel hotel = hotelRepository
                .findByHotelIdAndIsDeletedFalse(hotelId)
                .orElseThrow(() -> new ResourceNotFoundException("Hotel not found"));

        List<Room> rooms = roomRepository.findActiveByHotel(hotel);

        return rooms.stream()

                // bỏ phòng inactive và blocked
                .filter(room ->
                        room.getRoomStatus() != Room.RoomStatus.INACTIVE
                )

                .filter(room -> {

                    if (guest != null && room.getRoomType().getCapacity() < guest) {
                        return false;
                    }

                    // phòng bảo trì vẫn hiện
                    if(room.getRoomStatus() == Room.RoomStatus.MAINTENANCE){
                        return true;
                    }

                    // check phòng đang có khách
                    boolean isOverlap = billRepository.existsOverlapping(
                            room.getRoomId(),
                            checkIn,
                            checkOut
                    );

                    return !isOverlap;
                })

                .map(this::map)
                .toList();
    }

    @Override
    public List<RoomResponse> getRoomsByManager(Long managerId) {

        return roomRepository
                .findByManagerId(managerId)
                .stream()
                .map(this::map)
                .toList();
    }

}

