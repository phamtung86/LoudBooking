package com.example.loudhotel.service;

import com.example.loudhotel.dto.request.RoomRequest;
import com.example.loudhotel.dto.response.RoomResponse;

import java.time.LocalDate;
import java.util.List;

public interface RoomService {

    RoomResponse create(Long hotelId, RoomRequest request);

    List<RoomResponse> getByHotel(Long hotelId);

    void deleteRoom(Long roomId);

    List<RoomResponse> getAllRooms();

    RoomResponse getRoomById(Long id);

    RoomResponse update(Long id, RoomRequest request);

    List<RoomResponse> getAvailableRooms(
            Long hotelId,
            LocalDate checkIn,
            LocalDate checkOut,
            Integer guest
    );

    List<RoomResponse> getRoomsByManager(Long managerId);



}
