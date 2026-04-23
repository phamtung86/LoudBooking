package com.example.loudhotel.dto.response;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class ChatResponse {

    private Long chatId;
    private Long senderId;
    private String content;
    private LocalDateTime createdAt;
    private List<String> images;
}