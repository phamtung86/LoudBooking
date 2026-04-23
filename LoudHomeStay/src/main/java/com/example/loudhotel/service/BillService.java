package com.example.loudhotel.service;

import com.example.loudhotel.dto.request.BillRequest;
import com.example.loudhotel.dto.response.BillResponse;

import java.util.List;

public interface BillService {

    BillResponse create(Long userId, BillRequest request);

    BillResponse getById(Long billId);

    BillResponse pay(Long billId);

    BillResponse cancel(Long billId);

    BillResponse checkIn(Long billId);

    BillResponse checkOut(Long billId);

    BillResponse hold(Long billId);

    List<BillResponse> getAll();

    List<BillResponse> getByUser(Long userId);

    List<BillResponse> getBillsOfManager(Long managerId);
}
