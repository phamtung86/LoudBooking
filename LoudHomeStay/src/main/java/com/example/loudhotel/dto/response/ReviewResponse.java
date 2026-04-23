package com.example.loudhotel.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class ReviewResponse {

    private Long reviewId;
    private String username;
    private Double rate;
    private String comment;
    @JsonFormat(pattern = "HH:mm:ss dd/MM/yyyy", timezone = "Asia/Ho_Chi_Minh")
    private LocalDateTime createdAt;
    private String status; // ACTIVE | INACTIVE | PENDING
    private String hotelName;
    private boolean isMine;

    private String hotelStatus;
    private Long hotelId;
    private Long managerId; // hoặc hotel.managerId
}
