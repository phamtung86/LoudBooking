package com.example.loudhotel.controller;

import com.example.loudhotel.entity.Bill;
import com.example.loudhotel.repository.BillRepository;
import com.example.loudhotel.service.VNPayService;

import jakarta.servlet.http.HttpServletRequest;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final VNPayService vnPayService;
    private final BillRepository billRepository;

    @PostMapping("/vnpay")
    public String createPayment(@RequestParam Long billId,
                                HttpServletRequest httpRequest) {

        return vnPayService.createPaymentUrl(billId, httpRequest);
    }

    @GetMapping("/vnpay-return")
    public String paymentReturn(@RequestParam Map<String, String> params) {

        boolean valid = vnPayService.verifyPayment(params);

        if (!valid) {
            return "Sai chữ ký VNPay";
        }

        String responseCode =
                params.get("vnp_ResponseCode");

        String txnRef =
                params.get("vnp_TxnRef");

        Bill bill =
                billRepository.findByVnpTxnRef(txnRef)
                        .orElseThrow(
                                () -> new RuntimeException("Không tìm thấy bill")
                        );

        // tránh ghi đè bill đã bị scheduler cancel
        if (bill.getBillStatus() != Bill.BillStatus.PENDING) {
            return "Bill đã được xử lý trước đó";
        }

        if ("00".equals(responseCode)) {

            bill.setBillStatus(
                    Bill.BillStatus.PAID
            );

            bill.setStayStatus(
                    Bill.StayStatus.BOOKED
            );

        } else {

            bill.setBillStatus(
                    Bill.BillStatus.CANCELED
            );

            bill.setStayStatus(
                    Bill.StayStatus.CANCELED
            );

            bill.setCancelReason(
                    Bill.CancelReason.VNPAY_CANCEL
            );
        }

        bill.setVnpTransactionNo(
                params.get("vnp_TransactionNo")
        );

        bill.setUpdatedAt(
                LocalDateTime.now()
        );

        billRepository.save(bill);

        return "Thanh toán đặt phòng thành công! Vui lòng kiểm tra lại thông tin đặt phòng!";
    }
}