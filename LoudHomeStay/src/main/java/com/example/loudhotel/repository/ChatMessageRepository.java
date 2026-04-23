package com.example.loudhotel.repository;

import com.example.loudhotel.entity.ChatMessage;
import com.example.loudhotel.entity.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {

    List<ChatMessage> findByConversation_ConversationIdOrderByCreatedAtAsc(Long conversationId);

    boolean existsByConversation_ConversationId(Long conversationId);

    //List<Hotel> findByManager_UserId(Long managerId);
}