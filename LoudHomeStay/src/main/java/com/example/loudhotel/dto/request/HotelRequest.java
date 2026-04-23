package com.example.loudhotel.dto.request;

import com.example.loudhotel.entity.Hotel;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Data
public class HotelRequest {

    @NotBlank
    private String hotelName;

    @NotBlank
    private String hotelCode;

    private String address;
    private String introduction;
    private Hotel.HotelStatus hotelStatus;

    // danh sách id tiện ích
    private List<Long> utilitiesIds;
    private Long managerId;
}
