package com.example.loudhotel.repository;

import com.example.loudhotel.entity.Hotel;
import com.example.loudhotel.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface RoomRepository extends JpaRepository<Room, Long> {

    boolean existsByHotelAndRoomNumberAndIsDeletedFalse(Hotel hotel, Integer roomNumber);

    List<Room> findByIsDeletedFalse();

    List<Room> findByHotelAndIsDeletedFalse(Hotel hotel);

    long countByHotelAndIsDeletedFalse(Hotel hotel);

    @Query("""
SELECT r FROM Room r
WHERE r.isDeleted = false
AND r.hotel.isDeleted = false
""")
    List<Room> findAllActiveRooms();

    @Query("""
SELECT r FROM Room r
WHERE r.hotel = :hotel
AND r.isDeleted = false
AND r.hotel.isDeleted = false
""")
    List<Room> findActiveByHotel(Hotel hotel);

    @Query("""
SELECT r FROM Room r
WHERE r.isDeleted = false
AND r.hotel.isDeleted = false
AND r.hotel.manager.userId = :managerId
""")
    List<Room> findByManagerId(Long managerId);

    @Query("""
SELECT r FROM Room r
WHERE r.roomType.typeId = :typeId
AND r.isDeleted = false
AND r.roomStatus = 'ACTIVE'
AND NOT EXISTS (
    SELECT bd FROM BillDetail bd
    JOIN bd.bill b
    WHERE bd.room = r
    AND b.stayStatus IN ('BOOKED','HOLD','CHECKED_IN')
    AND b.checkInDate < :checkOut
    AND b.checkOutDate > :checkIn
)
""")
    List<Room> findAvailableRoomsByType(
            Long typeId,
            LocalDate checkIn,
            LocalDate checkOut
    );

    boolean existsByRoomType_TypeIdAndIsDeletedFalse(Long typeId);
}
