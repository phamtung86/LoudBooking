package com.example.loudhotel.controller;

import com.example.loudhotel.dto.request.BillRequest;
import com.example.loudhotel.dto.response.BillResponse;
import com.example.loudhotel.repository.BillRepository;
import com.example.loudhotel.repository.UserRepository;
import com.example.loudhotel.service.BillService;
import com.example.loudhotel.utils.SecurityUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bills")
@RequiredArgsConstructor
public class BillController {

    private final BillService billService;
    private final BillRepository billRepository;

    @GetMapping
    public Object getAll() {
        return billService.getAll();
    }

    @GetMapping("/my")
    public Object getMyBills(@RequestParam Long userId) {
        return billService.getByUser(userId);
    }

    @GetMapping("/{id}")
    public Object get(@PathVariable Long id) {
        return billService.getById(id);
    }

    @PostMapping
    public Object create(@RequestParam Long userId,
                         @RequestBody BillRequest request) {
        return billService.create(userId, request);
    }

    @PutMapping("/{id}/pay")
    public Object pay(@PathVariable Long id) {
        return billService.pay(id);
    }

    @PutMapping("/{id}/cancel")
    public Object cancel(@PathVariable Long id) {
        return billService.cancel(id);
    }

    @PutMapping("/{id}/check-in")
    public Object checkIn(@PathVariable Long id) {
        return billService.checkIn(id);
    }

    @PutMapping("/{id}/check-out")
    public Object checkOut(@PathVariable Long id) {
        return billService.checkOut(id);
    }

    @GetMapping("/manager")
    @PreAuthorize("hasRole('MANAGER')")
    public List<BillResponse> getBillsOfManager(){

        Long managerId =
                SecurityUtil.getCurrentUserId();

        return billService
                .getBillsOfManager(managerId);
    }

    @PutMapping("/{id}/hold")
    public Object hold(@PathVariable Long id) {
        return billService.hold(id);
    }

}
