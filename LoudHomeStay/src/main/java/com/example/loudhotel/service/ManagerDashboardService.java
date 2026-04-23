package com.example.loudhotel.service;

import com.example.loudhotel.dto.response.DashboardDTO;

import java.util.List;
import java.util.Map;

public interface ManagerDashboardService {

    DashboardDTO getOverview(Long managerId);

    DashboardDTO getByHotel(Long hotelId, Long managerId);

    DashboardDTO getByRange(Long managerId, String startDate, String endDate, Long hotelId);

    Map<String, List<?>> getChartYear(Long managerId, int year);

    Map<String, List<?>> getChartMonth(Long managerId, int year, int month);
}