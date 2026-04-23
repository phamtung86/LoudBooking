package com.example.loudhotel.service;

import com.example.loudhotel.dto.request.RoomTypeRequest;
import com.example.loudhotel.dto.response.RoomTypeResponse;

import java.util.List;

public interface RoomTypeService {
    List<RoomTypeResponse> getAll();

    RoomTypeResponse create(Long hotelId, RoomTypeRequest request);

    RoomTypeResponse update(Long id, RoomTypeRequest request);

    void delete(Long id);

    List<RoomTypeResponse> getByHotel(Long hotelId);

    RoomTypeResponse getById(Long id);

    List<RoomTypeResponse> getRoomTypesByManager(Long managerId);
}