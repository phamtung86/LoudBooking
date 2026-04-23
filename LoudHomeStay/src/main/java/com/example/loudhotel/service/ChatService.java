package com.example.loudhotel.service;

import com.example.loudhotel.dto.request.ChatRequest;
import com.example.loudhotel.dto.response.ChatResponse;
import com.example.loudhotel.dto.response.ConversationResponse;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface ChatService {

    Long createConversation(Long hotelId);

    ChatResponse sendMessage(ChatRequest request);

    List<ChatResponse> getMessages(Long conversationId);

    List<ConversationResponse> getUserConversations();

    List<ConversationResponse> getManagerConversations();

    List<String> uploadChatImages(List<MultipartFile> files);

    void markAsRead(Long conversationId);

    ConversationResponse getConversationInfo(Long conversationId);
}