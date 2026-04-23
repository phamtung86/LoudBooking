package com.example.loudhotel.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DashboardDTO {

    private double totalIncome;     // tổng tiền
    private long totalCompleted;    // số đơn completed
    private long totalReview;       // tổng review
}