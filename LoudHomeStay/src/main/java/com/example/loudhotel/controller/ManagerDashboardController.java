package com.example.loudhotel.controller;

import com.example.loudhotel.dto.response.DashboardDTO;
import com.example.loudhotel.service.ManagerDashboardService;
import com.example.loudhotel.utils.SecurityUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/manager/dashboard")
@RequiredArgsConstructor
public class ManagerDashboardController {

    private final ManagerDashboardService dashboardService;

    // ===== OVERVIEW =====
    @GetMapping("/overview")
    public DashboardDTO overview() {

        Long managerId = SecurityUtil.getCurrentUserId();

        return dashboardService.getOverview(managerId);
    }

    // ===== THEO HOTEL =====
    @GetMapping("/hotel/{hotelId}")
    public DashboardDTO byHotel(@PathVariable Long hotelId) {

        Long managerId = SecurityUtil.getCurrentUserId();

        return dashboardService.getByHotel(hotelId, managerId);
    }

    @GetMapping("/range")
    public DashboardDTO getByRange(
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam(required = false) Long hotelId
    ) {
        Long managerId = SecurityUtil.getCurrentUserId();
        return dashboardService.getByRange(managerId, startDate, endDate, hotelId);
    }

    @GetMapping("/chart-year")
    public Map<String, List<?>> chartYear(
            @RequestParam int year
    ) {
        Long managerId = SecurityUtil.getCurrentUserId();
        return dashboardService.getChartYear(managerId, year);
    }

    @GetMapping("/chart-month")
    public Map<String, List<?>> chartMonth(
            @RequestParam int year,
            @RequestParam int month
    ) {
        Long managerId = SecurityUtil.getCurrentUserId();
        return dashboardService.getChartMonth(managerId, year, month);
    }
}