package com.example.loudhotel.dto.response;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class ConversationResponse {
    private Long conversationId;
    private String hotelName;
    private String hotelImage;
    private Long hotelId;
    private Long managerId;

    private Long userId;
    private String username;

    private Long lastMessageSenderId;
    private Integer unreadCountManager;
    private Integer unreadCountUser;
    private LocalDateTime lastMessageAt;
}
