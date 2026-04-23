package com.example.loudhotel.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UtilitiesResponse {

    private Long id;          // utilities_id
    private String name;      // utilities_name

    private Long hotelId;  // homestay_id
    private String hotelName;
    private String hotelStatus;
}
