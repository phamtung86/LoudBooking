package com.example.loudhotel.repository;

import com.example.loudhotel.entity.Hotel;
import com.example.loudhotel.entity.Review;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends JpaRepository<Review, Long> {

    List<Review> findByHotel_HotelId(Long hotelId);

    Optional<Review> findByUser_UserIdAndHotel_HotelId(Long userId, Long hotelId);

    Page<Review> findAll(Pageable pageable);

    @Query("""
SELECT r FROM Review r
WHERE r.hotel.isDeleted = false
AND (:hotelStatus IS NULL OR r.hotel.hotelStatus = :hotelStatus)
AND (
    :keyword IS NULL OR
    LOWER(r.user.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
    LOWER(r.hotel.hotelName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
    LOWER(r.comment) LIKE LOWER(CONCAT('%', :keyword, '%'))
)
AND (:rate IS NULL OR r.rate = :rate)
AND (:minRate IS NULL OR r.rate >= :minRate)
AND (:maxRate IS NULL OR r.rate < :maxRate)
""")
    Page<Review> searchReviews(@Param("keyword") String keyword,
                               @Param("rate") Double rate,
                               @Param("minRate") Double minRate,
                               @Param("maxRate") Double maxRate,
                               @Param("hotelStatus") Hotel.HotelStatus hotelStatus,
                               Pageable pageable);
    @Modifying
    @Query("UPDATE Review r SET r.status = :status WHERE r.reviewId = :id")
    void updateStatus(@Param("id") Long id,
                      @Param("status") Review.ReviewStatus status);

    @Query("""
SELECT r FROM Review r
WHERE r.hotel.isDeleted = false
""")
    Page<Review> findAllVisible(Pageable pageable);

    @Query("""
SELECT r FROM Review r
WHERE r.reviewId = :reviewId
AND r.hotel.manager.userId = :managerId
""")
    Optional<Review> findByIdAndManagerId(Long reviewId, Long managerId);


    @Query("""
SELECT r FROM Review r
WHERE r.hotel.isDeleted = false
AND r.hotel.manager.userId = :managerId
AND (:hotelStatus IS NULL OR r.hotel.hotelStatus = :hotelStatus)
AND (
    :keyword IS NULL OR
    LOWER(r.user.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
    LOWER(r.hotel.hotelName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
    LOWER(r.comment) LIKE LOWER(CONCAT('%', :keyword, '%'))
)
AND (:rate IS NULL OR r.rate = :rate)
AND (:minRate IS NULL OR r.rate >= :minRate)
AND (:maxRate IS NULL OR r.rate < :maxRate)
""")
    Page<Review> searchReviewsByManager(
            @Param("managerId") Long managerId,
            @Param("keyword") String keyword,
            @Param("rate") Double rate,
            @Param("minRate") Double minRate,
            @Param("maxRate") Double maxRate,
            @Param("hotelStatus") Hotel.HotelStatus hotelStatus,
            Pageable pageable
    );
}
