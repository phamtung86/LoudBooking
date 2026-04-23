package com.example.loudhotel.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "bills")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Bill {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long billId;

    @Column(name = "bill_code", unique = true, nullable = false)
    private String billCode;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hotel_id", nullable = false)
    private Hotel hotel;

    @OneToMany(mappedBy = "bill", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<BillDetail> billDetails;

    private String orderName;
    private String orderEmail;
    private String orderPhone;

    private LocalDate checkInDate;
    private LocalDate checkOutDate;

    private LocalDateTime actualCheckInTime;
    private LocalDateTime actualCheckOutTime;

    private Double totalCost;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @Enumerated(EnumType.STRING)
    private BillStatus billStatus;

    @Enumerated(EnumType.STRING)
    private StayStatus stayStatus;

    @Enumerated(EnumType.STRING)
    private PaymentMethod paymentMethod;

    @Enumerated(EnumType.STRING)
    private CancelReason cancelReason;

    public enum BillStatus {
        PENDING, PAID, CANCELED
    }

    public enum StayStatus {
        BOOKED,
        HOLD,
        CHECKED_IN,
        COMPLETED,
        CANCELED
    }

    public enum PaymentMethod {
        CASH, VNPAY
    }

    public enum CancelReason {
        USER_CANCEL,
        HOTEL_CANCEL,
        NO_SHOW,
        VNPAY_CANCEL
    }

    private String vnpTxnRef;   // mã giao dịch gửi sang VNPay
    private String vnpTransactionNo; // mã VNPay trả về
}