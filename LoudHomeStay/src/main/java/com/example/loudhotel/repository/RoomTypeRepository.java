package com.example.loudhotel.repository;

import com.example.loudhotel.entity.RoomType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface RoomTypeRepository extends JpaRepository<RoomType, Long> {

    @Query("SELECT rt FROM RoomType rt LEFT JOIN FETCH rt.images WHERE rt.hotel.hotelId = :hotelId AND rt.isDeleted = false")
    List<RoomType> findByHotel_HotelIdAndIsDeletedFalse(@Param("hotelId") Long hotelId);

    Optional<RoomType> findByTypeIdAndIsDeletedFalse(Long id);

    List<RoomType> findByIsDeletedFalse();
    boolean existsByHotel_HotelIdAndTypeNameAndIsDeletedFalse(Long hotelId, String typeName);

    boolean existsByHotel_HotelIdAndIsDeletedFalse(Long hotelId);
}
