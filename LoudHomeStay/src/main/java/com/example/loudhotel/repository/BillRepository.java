package com.example.loudhotel.repository;

import com.example.loudhotel.entity.Bill;
import com.example.loudhotel.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface BillRepository extends JpaRepository<Bill, Long> {
    List<Bill> findByStayStatusIn(List<Bill.StayStatus> statuses);

    List<Bill> findByCheckInDate(LocalDate date);

    Optional<Bill> findByVnpTxnRef(String vnpTxnRef);

    List<Bill> findByUser_UserId(Long userId);

    List<Bill> findByStayStatus(Bill.StayStatus stayStatus);

    List<Bill> findByHotel_Manager_UserId(Long managerId);

    List<Bill> findByHotel_HotelId(Long hotelId);

    List<Bill> findByBillStatus(Bill.BillStatus status);

    List<Bill> findByUser(User user);

    @Query("""
SELECT COUNT(bd) > 0
FROM BillDetail bd
JOIN bd.bill b
WHERE bd.room.roomId = :roomId
AND b.stayStatus IN ('BOOKED','HOLD','CHECKED_IN')
AND b.checkInDate < :checkOut
AND b.checkOutDate > :checkIn
""")
    boolean existsOverlapping(
            @Param("roomId") Long roomId,
            @Param("checkIn") LocalDate checkIn,
            @Param("checkOut") LocalDate checkOut
    );


    @Query("""
SELECT COUNT(bd) > 0
FROM BillDetail bd
JOIN bd.bill b
WHERE bd.room.roomId = :roomId
AND b.billId <> :billId
AND b.stayStatus IN ('BOOKED','HOLD','CHECKED_IN')
AND (
    b.checkInDate < :checkOut
    AND b.checkOutDate > :checkIn
)
""")
    boolean existsActiveBooking(
            @Param("roomId") Long roomId,
            @Param("billId") Long billId,
            @Param("checkIn") LocalDate checkIn,
            @Param("checkOut") LocalDate checkOut
    );

    @Query("""
SELECT COUNT(bd) > 0
FROM BillDetail bd
JOIN bd.bill b
WHERE bd.room.roomId = :roomId
AND b.billId <> :billId
AND b.stayStatus = 'CHECKED_IN'
""")
    boolean existsRoomBeingUsed(
            @Param("roomId") Long roomId,
            @Param("billId") Long billId
    );

    List<Bill> findByBillStatusAndCreatedAtBefore(
            Bill.BillStatus status,
            LocalDateTime time
    );

    boolean existsByBillCode(String billCode);


}
