package com.example.loudhotel.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ChatUserResponse {
    private Long userId;
    private String username;
    private String role;
}