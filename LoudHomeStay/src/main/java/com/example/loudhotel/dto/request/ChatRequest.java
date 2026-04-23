package com.example.loudhotel.dto.request;

import lombok.Data;

import java.util.List;

@Data
public class ChatRequest {

    private Long hotelId;       // dùng khi tạo conversation
    private Long conversationId; // dùng khi gửi tin

    private String content;
    private List<String> images;
}