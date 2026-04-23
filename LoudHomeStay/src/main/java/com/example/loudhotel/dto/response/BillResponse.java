package com.example.loudhotel.dto.response;

import com.example.loudhotel.entity.Bill;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder

public class BillResponse {

    private Long billId;

    private String billCode;

    private Long userId;
    private String userName;

    private Long hotelId;
    private String hotelName;


    private String orderName;
    private String orderEmail;
    private String orderPhone;

    private LocalDate checkInDate;
    private LocalDate checkOutDate;

    private Double totalCost;

    private Bill.BillStatus billStatus;
    private Bill.StayStatus stayStatus;
    private Bill.PaymentMethod paymentMethod;

    private LocalDateTime createdAt;

    private LocalDateTime actualCheckInTime;
    private LocalDateTime actualCheckOutTime;

    private LocalDateTime updatedAt;

    private Bill.CancelReason cancelReason;

    private String hotelAddress;
    private String managerEmail;

    private List<RoomItem> rooms;
    @Data
    @Builder
    public static class RoomItem {
        private Long roomId;
        private String roomName;
        private Double oldPrice;
        private Integer nights;
        private Double subtotal;
        private String roomType;
        private Integer capacity;
        private Integer roomNumber;
    }
}
