package com.example.loudhotel.repository;

import com.example.loudhotel.entity.Conversation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ConversationRepository extends JpaRepository<Conversation, Long> {

    Optional<Conversation> findByHotel_HotelIdAndUser_UserId(Long hotelId, Long userId);

    List<Conversation> findByUser_UserId(Long userId);

    List<Conversation> findByManager_UserId(Long managerId);
    List<Conversation> findByHotel_HotelId(Long hotelId);
}