package com.example.loudhotel.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "bill_details")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BillDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long billDetailId;

    @ManyToOne
    @JoinColumn(name = "bill_id", nullable = false)
    private Bill bill;

    @ManyToOne
    @JoinColumn(name = "type_id")
    private RoomType roomType;

    // chỉ set khi check-in
    @ManyToOne
    @JoinColumn(name = "room_id")
    private Room room;

    private Double oldPrice;   // bạn giữ OK 👍
    private Integer nights;
    private Double subtotal;
}