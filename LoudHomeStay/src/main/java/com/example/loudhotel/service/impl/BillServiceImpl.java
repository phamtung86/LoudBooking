package com.example.loudhotel.service.impl;

import com.example.loudhotel.dto.request.BillRequest;
import com.example.loudhotel.dto.response.BillResponse;
import com.example.loudhotel.entity.*;
import com.example.loudhotel.exception.BadRequestException;
import com.example.loudhotel.exception.ResourceNotFoundException;
import com.example.loudhotel.repository.*;
import com.example.loudhotel.service.BillService;
import com.example.loudhotel.utils.SecurityUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

@Service
@RequiredArgsConstructor
public class BillServiceImpl implements BillService {

    private final BillRepository billRepository;
    private final UserRepository userRepository;
    private final RoomRepository roomRepository;
    private final HotelRepository hotelRepository;
    private final RoomTypeRepository roomTypeRepository;

    private BillResponse toResponse(Bill bill) {

        List<BillResponse.RoomItem> rooms = bill.getBillDetails()
                .stream()
                .map(bd -> BillResponse.RoomItem.builder()
                        .roomId(bd.getRoom() != null ? bd.getRoom().getRoomId() : null)
                        .roomNumber(bd.getRoom() != null ? bd.getRoom().getRoomNumber() : null)
                        .roomType(bd.getRoomType().getTypeName())
                        .capacity(bd.getRoomType().getCapacity())
                        .oldPrice(bd.getOldPrice())
                        .nights(bd.getNights())
                        .subtotal(bd.getSubtotal())
                        .build()
                )
                .toList();

        return BillResponse.builder()
                .billId(bill.getBillId())
                .billCode(bill.getBillCode())

                .userId(bill.getUser().getUserId())
                .userName(bill.getUser().getUsername())

                .hotelId(bill.getHotel().getHotelId())
                .hotelName(bill.getHotel().getHotelName())
                .hotelAddress(bill.getHotel().getAddress())
                .managerEmail(bill.getHotel().getManager().getEmail())

                .orderName(bill.getOrderName())
                .orderEmail(bill.getOrderEmail())
                .orderPhone(bill.getOrderPhone())

                .checkInDate(bill.getCheckInDate())
                .checkOutDate(bill.getCheckOutDate())

                .totalCost(bill.getTotalCost())

                .billStatus(bill.getBillStatus())
                .stayStatus(bill.getStayStatus())
                .paymentMethod(bill.getPaymentMethod())
                .cancelReason(bill.getCancelReason())

                .actualCheckInTime(bill.getActualCheckInTime())
                .actualCheckOutTime(bill.getActualCheckOutTime())

                .createdAt(bill.getCreatedAt())
                .updatedAt(bill.getUpdatedAt())

                .rooms(rooms)
                .build();
    }

    @Override
    public List<BillResponse> getAll() {
        return billRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    public List<BillResponse> getBillsOfManager(Long managerId) {

        return billRepository
                .findByHotel_Manager_UserId(managerId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    public BillResponse create(Long userId, BillRequest request) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User không tồn tại"));

        Hotel hotel = hotelRepository.findById(request.getHotelId())
                .orElseThrow(() -> new ResourceNotFoundException("Hotel không tồn tại"));

        long nights = ChronoUnit.DAYS.between(
                request.getCheckInDate(),
                request.getCheckOutDate()
        );

        if (nights <= 0) {
            throw new BadRequestException("Check-out phải sau check-in");
        }

        List<BillDetail> details = new ArrayList<>();
        double totalCost = 0;

        for (BillRequest.RoomSelection r : request.getRooms()) {

            RoomType roomType = roomTypeRepository.findById(r.getTypeId())
                    .orElseThrow(() -> new RuntimeException("Room type not found"));

            List<Room> availableRooms = roomRepository
                    .findAvailableRoomsByType(
                            roomType.getTypeId(),
                            request.getCheckInDate(),
                            request.getCheckOutDate()
                    );

            if (availableRooms.size() < r.getQuantity()) {
                throw new BadRequestException("Không đủ phòng trống");
            }

            double price = roomType.getPrice();

            // ✅ QUAN TRỌNG: tách từng phòng
            for (int i = 0; i < r.getQuantity(); i++) {

                BillDetail bd = BillDetail.builder()
                        .roomType(roomType)
                        .room(null)
                        .oldPrice(price)
                        .nights((int) nights)
                        .subtotal(price * nights)
                        .build();

                details.add(bd);
                totalCost += bd.getSubtotal();
            }
        }

        Bill.PaymentMethod method =
                Bill.PaymentMethod.valueOf(request.getPaymentMethod().toUpperCase());

        Bill bill = Bill.builder()
                .user(user)
                .hotel(hotel)
                .billCode(generateBillCode())
                .orderName(request.getOrderName())
                .orderEmail(request.getOrderEmail())
                .orderPhone(request.getOrderPhone())
                .checkInDate(request.getCheckInDate())
                .checkOutDate(request.getCheckOutDate())
                .totalCost(totalCost)
                .stayStatus(Bill.StayStatus.BOOKED)
                .paymentMethod(method)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        for (BillDetail bd : details) {
            bd.setBill(bill);
        }

        bill.setBillDetails(details);

        if (method == Bill.PaymentMethod.CASH) {
            bill.setBillStatus(Bill.BillStatus.PENDING);
        } else {
            bill.setBillStatus(Bill.BillStatus.PENDING);
            bill.setVnpTxnRef(UUID.randomUUID().toString().replace("-", ""));
        }

        billRepository.save(bill);

        return toResponse(bill);
    }

    private void checkManagerPermission(Bill bill){

        Long currentUserId =
                SecurityUtil.getCurrentUserId();

        Long managerId =
                bill.getHotel().getManager().getUserId();

        if(!managerId.equals(currentUserId)){

            throw new BadRequestException(
                    "Không có quyền thao tác bill này"
            );
        }
    }

    @Override
    public BillResponse pay(Long billId) {

        Bill bill = getBill(billId);

        // THÊM ĐOẠN NÀY
        if (bill.getHotel() == null || bill.getHotel().getManager() == null) {
            throw new BadRequestException("Hotel hoặc manager không hợp lệ");
        }

        if (bill.getCheckInDate() == null) {
            throw new BadRequestException("Thiếu ngày check-in");
        }

        checkManagerPermission(bill);

        if(bill.getPaymentMethod()
                != Bill.PaymentMethod.CASH){

            throw new BadRequestException(
                    "Chỉ áp dụng cho thanh toán tại quầy"
            );
        }

        bill.setBillStatus(Bill.BillStatus.PAID);

        bill.setUpdatedAt(LocalDateTime.now());

        return toResponse(billRepository.save(bill));
    }

    @Override
    public BillResponse cancel(Long billId) {

        Bill bill = getBill(billId);

        Long currentUserId = SecurityUtil.getCurrentUserId();

        boolean isManager =
                bill.getHotel().getManager().getUserId().equals(currentUserId);

        boolean isUser =
                bill.getUser().getUserId().equals(currentUserId);

        if(!isManager && !isUser){
            throw new BadRequestException("Không có quyền hủy đơn này");
        }

        if(bill.getStayStatus() == Bill.StayStatus.CHECKED_IN){
            throw new BadRequestException("Đang ở không thể hủy");
        }

        // USER chỉ được hủy trước 12h ngày check-in
        if(isUser){

            LocalDateTime limit =
                    bill.getCheckInDate().atTime(12,0);

            if(LocalDateTime.now().isAfter(limit)){
                throw new BadRequestException(
                        "Chỉ được hủy trước 12h ngày check-in"
                );
            }
        }

        // ===== logic theo yêu cầu =====

        if(bill.getStayStatus() == Bill.StayStatus.HOLD){

            bill.setCancelReason(Bill.CancelReason.NO_SHOW);

        }else{

            if(isUser){
                bill.setCancelReason(Bill.CancelReason.USER_CANCEL);
            }

            if(isManager){
                bill.setCancelReason(Bill.CancelReason.HOTEL_CANCEL);
            }
        }

        bill.setStayStatus(Bill.StayStatus.CANCELED);
        bill.setBillStatus(Bill.BillStatus.CANCELED);
        bill.setUpdatedAt(LocalDateTime.now());

        return toResponse(
                billRepository.save(bill)
        );
    }

    @Override
    public BillResponse checkIn(Long billId) {

        Bill bill = getBill(billId);

        checkManagerPermission(bill);

        if (bill.getPaymentMethod() == Bill.PaymentMethod.CASH
                && bill.getBillStatus() == Bill.BillStatus.PENDING) {
            throw new BadRequestException("Chưa thanh toán");
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime checkinTime = bill.getCheckInDate().atTime(14, 0);

        if (now.isBefore(checkinTime)) {
            throw new BadRequestException("Chỉ được check-in từ 14h");
        }

        // ✅ nhóm theo type để tránh gọi query nhiều lần
        var grouped = bill.getBillDetails()
                .stream()
                .filter(bd -> bd.getRoom() == null)
                .collect(java.util.stream.Collectors.groupingBy(
                        bd -> bd.getRoomType().getTypeId()
                ));

        for (var entry : grouped.entrySet()) {

            Long typeId = entry.getKey();
            List<BillDetail> list = entry.getValue();

            List<Room> availableRooms = roomRepository
                    .findAvailableRoomsByType(
                            typeId,
                            bill.getCheckInDate(),
                            bill.getCheckOutDate()
                    );

            if (availableRooms.size() < list.size()) {
                throw new BadRequestException("Không đủ phòng để gán");
            }

            for (int i = 0; i < list.size(); i++) {
                list.get(i).setRoom(availableRooms.get(i));
            }
        }

        bill.setStayStatus(Bill.StayStatus.CHECKED_IN);
        bill.setActualCheckInTime(now);
        bill.setUpdatedAt(now);

        return toResponse(billRepository.save(bill));
    }

    @Override
    public BillResponse checkOut(Long billId) {

        Bill bill = getBill(billId);

        checkManagerPermission(bill);

        if (bill.getStayStatus() != Bill.StayStatus.CHECKED_IN) {
            throw new BadRequestException("Chưa check-in");
        }

        LocalDateTime now = LocalDateTime.now();

        bill.setActualCheckOutTime(now);

        bill.setStayStatus(Bill.StayStatus.COMPLETED);

        bill.setUpdatedAt(now);

        billRepository.save(bill);

        return toResponse(bill);
    }


    @Override
    public BillResponse hold(Long billId) {

        Bill bill = getBill(billId);

        Long currentUserId = SecurityUtil.getCurrentUserId();

        boolean isManager =
                bill.getHotel().getManager().getUserId().equals(currentUserId);

        boolean isUser =
                bill.getUser().getUserId().equals(currentUserId);

        if(!isManager && !isUser){
            throw new BadRequestException("Không có quyền giữ phòng này");
        }

        if (bill.getStayStatus() != Bill.StayStatus.BOOKED) {
            throw new BadRequestException("Chỉ giữ khi BOOKED");
        }

        LocalDateTime now = LocalDateTime.now();

        LocalDateTime allowHoldTime =
                bill.getCheckInDate().atTime(14, 0);

        if(now.isBefore(allowHoldTime)){
            throw new BadRequestException(
                    "Chỉ được giữ phòng sau 14h ngày check-in"
            );
        }

        bill.setStayStatus(Bill.StayStatus.HOLD);
        bill.setUpdatedAt(now);

        return toResponse(billRepository.save(bill));
    }

    @Scheduled(fixedRate = 60000)
    public void autoCancelExpiredVnpayBills() {

        LocalDateTime timeout =
                LocalDateTime.now().minusMinutes(1);

        List<Bill> bills =
                billRepository.findByBillStatusAndCreatedAtBefore(
                        Bill.BillStatus.PENDING,
                        timeout
                );

        for (Bill bill : bills) {

            if (bill.getPaymentMethod()
                    == Bill.PaymentMethod.VNPAY) {

                bill.setBillStatus(
                        Bill.BillStatus.CANCELED
                );

                bill.setStayStatus(
                        Bill.StayStatus.CANCELED
                );

                bill.setCancelReason(
                        Bill.CancelReason.VNPAY_CANCEL
                );

                bill.setUpdatedAt(
                        LocalDateTime.now()
                );
            }
        }

        billRepository.saveAll(bills);
    }

    @Override
    public BillResponse getById(Long id) {
        return toResponse(getBill(id));
    }

    private Bill getBill(Long id) {
        return billRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Bill không tồn tại"));
    }

    @Override
    public List<BillResponse> getByUser(Long userId) {
        return billRepository.findByUser_UserId(userId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    private String generateBillCode() {

        String prefix = "BLB";

        String datePart = java.time.LocalDate.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd"));

        while (true) {

            int random = ThreadLocalRandom.current()
                    .nextInt(10000, 100000); // 5 số

            String code = prefix + datePart + random;

            if (!billRepository.existsByBillCode(code)) {
                return code;
            }
        }
    }
}