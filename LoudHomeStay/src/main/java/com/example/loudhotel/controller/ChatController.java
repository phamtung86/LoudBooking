package com.example.loudhotel.controller;

import com.example.loudhotel.dto.request.ChatRequest;
import com.example.loudhotel.dto.response.ChatResponse;
import com.example.loudhotel.dto.response.ConversationResponse;
import com.example.loudhotel.service.ChatService;
import com.example.loudhotel.service.ImageService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import org.springframework.messaging.simp.SimpMessagingTemplate;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;

    @PostMapping("/conversation/{hotelId}")
    public Long createConversation(@PathVariable Long hotelId) {
        return chatService.createConversation(hotelId);
    }

    @PostMapping("/send")
    public ChatResponse sendMessage(@RequestBody ChatRequest request) {

        ChatResponse res = chatService.sendMessage(request);

        ConversationResponse conv =
                chatService.getConversationInfo(request.getConversationId());

        // realtime cho người đang mở chat
        messagingTemplate.convertAndSend(
                "/topic/chat/" + request.getConversationId(),
                res
        );

        // realtime cho MANAGER (update list + unread)
        messagingTemplate.convertAndSend(
                "/topic/manager/" + conv.getManagerId(),
                res
        );

        // realtime cho USER (update list + unread)
        messagingTemplate.convertAndSend(
                "/topic/user/" + conv.getUserId(),
                res
        );

        return res;
    }

    @GetMapping("/{conversationId}")
    public List<ChatResponse> getMessages(@PathVariable Long conversationId) {
        return chatService.getMessages(conversationId);
    }

    @GetMapping("/user")
    public List<ConversationResponse> getUserConversations() {
        return chatService.getUserConversations();
    }

    @GetMapping("/manager")
    public List<ConversationResponse> getManagerConversations() {
        return chatService.getManagerConversations();
    }

    @PostMapping("/upload")
    public List<String> uploadImages(@RequestParam("files") List<MultipartFile> files) {
        return chatService.uploadChatImages(files);
    }

    @PostMapping("/read/{conversationId}")
    public void markAsRead(@PathVariable Long conversationId) {

        chatService.markAsRead(conversationId);

        ConversationResponse conv = chatService.getConversationInfo(conversationId);

        // bắn realtime cập nhật unread = 0
        messagingTemplate.convertAndSend(
                "/topic/user/" + conv.getUserId(),
                conv
        );

        messagingTemplate.convertAndSend(
                "/topic/manager/" + conv.getManagerId(),
                conv
        );
    }
}