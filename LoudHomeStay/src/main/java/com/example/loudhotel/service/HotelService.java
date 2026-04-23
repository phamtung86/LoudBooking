package com.example.loudhotel.service;

import com.example.loudhotel.dto.request.HotelRequest;
import com.example.loudhotel.dto.response.HotelResponse;

import java.util.List;

public interface HotelService {

    HotelResponse createHotel(HotelRequest request);

    HotelResponse getHotelById(Long hotelId);

    List<HotelResponse> getAll();

    List<HotelResponse> searchAll(String keyword);

    void deleteHotel(Long id);

    HotelResponse updateHotel(Long id, HotelRequest request);

    List<HotelResponse> getMyHotels();

}
