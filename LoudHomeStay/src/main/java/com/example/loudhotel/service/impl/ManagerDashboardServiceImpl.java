package com.example.loudhotel.service.impl;

import com.example.loudhotel.dto.response.DashboardDTO;
import com.example.loudhotel.entity.Bill;
import com.example.loudhotel.repository.BillRepository;
import com.example.loudhotel.repository.ReviewRepository;
import com.example.loudhotel.service.ManagerDashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ManagerDashboardServiceImpl implements ManagerDashboardService {

    private final BillRepository billRepository;
    private final ReviewRepository reviewRepository;

    // ===== Manager OVERVIEW =====
    @Override
    public DashboardDTO getOverview(Long managerId) {

        // ===== BILL =====
        List<Bill> bills = billRepository.findByHotel_Manager_UserId(managerId);

        double totalIncome = bills.stream()
                .filter(b -> b.getStayStatus() == Bill.StayStatus.COMPLETED)
                .mapToDouble(Bill::getTotalCost)
                .sum();

        long totalCompleted = bills.stream()
                .filter(b -> b.getStayStatus() == Bill.StayStatus.COMPLETED)
                .count();

        // ===== REVIEW =====
        long totalReview =
                reviewRepository.searchReviewsByManager(
                        managerId, null, null, null, null, null, null
                ).getTotalElements();

        return new DashboardDTO(
                totalIncome,
                totalCompleted,
                totalReview
        );
    }

    // ===== BY HOTEL =====
    @Override
    public DashboardDTO getByHotel(Long hotelId, Long managerId) {

        // ===== BILL =====
        List<Bill> bills = billRepository.findByHotel_HotelId(hotelId);

        double totalIncome = bills.stream()
                .filter(b -> b.getStayStatus() == Bill.StayStatus.COMPLETED)
                .mapToDouble(Bill::getTotalCost)
                .sum();

        long totalCompleted = bills.stream()
                .filter(b -> b.getStayStatus() == Bill.StayStatus.COMPLETED)
                .count();

        // ===== REVIEW =====
        long totalReview =
                reviewRepository.findByHotel_HotelId(hotelId).size();

        return new DashboardDTO(
                totalIncome,
                totalCompleted,
                totalReview
        );
    }

    @Override
    public DashboardDTO getByRange(Long managerId, String startDate, String endDate, Long hotelId) {

        LocalDate start = LocalDate.parse(startDate);
        LocalDate end = LocalDate.parse(endDate);

        List<Bill> bills;

        if (hotelId != null) {
            bills = billRepository.findByHotel_HotelId(hotelId);
        } else {
            bills = billRepository.findByHotel_Manager_UserId(managerId);
        }

        // ===== BILL =====
        List<Bill> filteredBills = bills.stream()
                .filter(b -> b.getStayStatus() == Bill.StayStatus.COMPLETED)
                .filter(b -> {
                    if (b.getCheckOutDate() == null) return false;
                    LocalDate d = b.getCheckOutDate();
                    return !d.isBefore(start) && !d.isAfter(end);
                })
                .toList();

        double totalIncome = filteredBills.stream()
                .mapToDouble(Bill::getTotalCost)
                .sum();

        long totalCompleted = filteredBills.size();

        // ===== REVIEW =====
        long totalReview;

        if (hotelId != null) {
            totalReview = reviewRepository.findByHotel_HotelId(hotelId).stream()
                    .filter(r -> {
                        LocalDate d = r.getCreatedAt().toLocalDate();
                        return !d.isBefore(start) && !d.isAfter(end);
                    })
                    .count();
        } else {
            totalReview = reviewRepository.searchReviewsByManager(
                            managerId, null, null, null, null, null, null
                    ).getContent().stream()
                    .filter(r -> {
                        LocalDate d = r.getCreatedAt().toLocalDate();
                        return !d.isBefore(start) && !d.isAfter(end);
                    })
                    .count();
        }

        return new DashboardDTO(
                totalIncome,
                totalCompleted,
                totalReview
        );
    }

    @Override
    public Map<String, List<?>> getChartYear(Long managerId, int year) {

        List<Bill> bills = billRepository.findByHotel_Manager_UserId(managerId);

        double[] income = new double[12];
        double[] debt = new double[12];
        int[] completed = new int[12];
        int[] review = new int[12];

        for (Bill b : bills) {
            if (b.getCheckOutDate() == null) continue;

            if (b.getCheckOutDate().getYear() == year) {
                int month = b.getCheckOutDate().getMonthValue() - 1;

                if (b.getStayStatus() == Bill.StayStatus.COMPLETED) {
                    income[month] += b.getTotalCost();
                    completed[month]++;
                }
            }
        }

        reviewRepository.searchReviewsByManager(
                managerId, null, null, null, null, null, null
        ).getContent().forEach(r -> {
            if (r.getCreatedAt().getYear() == year) {
                int month = r.getCreatedAt().getMonthValue() - 1;
                review[month]++;
            }
        });

        return Map.of(
                "income", Arrays.stream(income).boxed().toList(),
                "debt", Arrays.stream(debt).boxed().toList(),
                "completed", Arrays.stream(completed).boxed().toList(),
                "review", Arrays.stream(review).boxed().toList()
        );
    }

    private int findWeekIndex(LocalDate date, List<LocalDate[]> weeks) {
        for (int i = 0; i < weeks.size(); i++) {
            LocalDate start = weeks.get(i)[0];
            LocalDate end = weeks.get(i)[1];

            if (!date.isBefore(start) && !date.isAfter(end)) {
                return i;
            }
        }
        return -1;
    }

    @Override
    public Map<String, List<?>> getChartMonth(Long managerId, int year, int month) {

        // ===== 1. TẠO DANH SÁCH TUẦN =====
        List<LocalDate[]> weeks = new ArrayList<>();
        List<String> labels = new ArrayList<>();

        LocalDate start = LocalDate.of(year, month, 1);
        LocalDate end = start.withDayOfMonth(start.lengthOfMonth());

        // 👉 Lùi về thứ 2 gần nhất
        LocalDate current = start.with(java.time.DayOfWeek.MONDAY);
        if (current.isAfter(start)) {
            current = current.minusWeeks(1);
        }

        while (!current.isAfter(end)) {

            LocalDate weekStart = current;
            LocalDate weekEnd = current.plusDays(6);

            // 👉 Cắt theo phạm vi tháng
            LocalDate realStart = weekStart.isBefore(start) ? start : weekStart;
            LocalDate realEnd = weekEnd.isAfter(end) ? end : weekEnd;

            weeks.add(new LocalDate[]{realStart, realEnd});

            labels.add(String.format("%02d-%02d",
                    realStart.getDayOfMonth(),
                    realEnd.getDayOfMonth()
            ));

            current = current.plusWeeks(1);
        }

        int size = weeks.size();

        double[] income = new double[size];
        double[] debt = new double[size];
        int[] completed = new int[size];
        int[] review = new int[size];

        // ===== 2. BILL =====
        List<Bill> bills = billRepository.findByHotel_Manager_UserId(managerId);

        for (Bill b : bills) {
            if (b.getCheckOutDate() == null) continue;

            LocalDate d = b.getCheckOutDate();

            if (d.getYear() == year && d.getMonthValue() == month) {

                int weekIndex = findWeekIndex(d, weeks);
                if (weekIndex == -1) continue;

                if (b.getStayStatus() == Bill.StayStatus.COMPLETED) {
                    income[weekIndex] += b.getTotalCost();
                    completed[weekIndex]++;
                }
            }
        }

        // ===== 4. REVIEW =====
        reviewRepository.searchReviewsByManager(
                managerId, null, null, null, null, null, null
        ).getContent().forEach(r -> {

            LocalDate d = r.getCreatedAt().toLocalDate();

            if (d.getYear() == year && d.getMonthValue() == month) {

                int weekIndex = findWeekIndex(d, weeks);
                if (weekIndex != -1) {
                    review[weekIndex]++;
                }
            }
        });

        // ===== 5. RETURN =====
        return Map.of(
                "labels", labels,
                "income", Arrays.stream(income).boxed().toList(),
                "debt", Arrays.stream(debt).boxed().toList(),
                "completed", Arrays.stream(completed).boxed().toList(),
                "review", Arrays.stream(review).boxed().toList()
        );
    }
}