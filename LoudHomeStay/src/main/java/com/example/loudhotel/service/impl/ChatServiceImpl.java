package com.example.loudhotel.service.impl;

import com.example.loudhotel.config.FileStorageConfig;
import com.example.loudhotel.dto.request.ChatRequest;
import com.example.loudhotel.dto.response.ChatResponse;
import com.example.loudhotel.dto.response.ConversationResponse;
import com.example.loudhotel.dto.response.HotelResponse;
import com.example.loudhotel.entity.*;
import com.example.loudhotel.exception.ResourceNotFoundException;
import com.example.loudhotel.repository.*;
import com.example.loudhotel.service.ChatService;
import com.example.loudhotel.service.HotelService;
import com.example.loudhotel.utils.SecurityUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import static java.util.stream.Collectors.toList;

@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final ConversationRepository conversationRepository;
    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository;
    private final HotelRepository hotelRepository;
    private final ChatImageRepository chatImageRepository;
    private final HotelService hotelService;

    @Override
    public Long createConversation(Long hotelId) {

        Long userId = SecurityUtil.getCurrentUserId();

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Hotel hotel = hotelRepository.findById(hotelId)
                .orElseThrow(() -> new ResourceNotFoundException("Hotel not found"));

        User manager = hotel.getManager();

        return conversationRepository
                .findByHotel_HotelIdAndUser_UserId(hotelId, userId)
                .orElseGet(() -> {
                    Conversation c = Conversation.builder()
                            .hotel(hotel)
                            .user(user)
                            .manager(manager)
                            .createdAt(LocalDateTime.now())
                            .build();

                    return conversationRepository.save(c);
                })
                .getConversationId();
    }

    @Override
    public ChatResponse sendMessage(ChatRequest request) {

        Long userId = SecurityUtil.getCurrentUserId();

        User sender = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Conversation conversation = conversationRepository.findById(request.getConversationId())
                .orElseThrow(() -> new ResourceNotFoundException("Conversation not found"));

        conversation.setLastMessageSenderId(sender.getUserId());
        conversation.setLastMessageAt(LocalDateTime.now());

        if (sender.getUserId().equals(conversation.getManager().getUserId())) {
            conversation.setUnreadCountUser(
                    (conversation.getUnreadCountUser() == null ? 0 : conversation.getUnreadCountUser()) + 1
            );
        } else {
            conversation.setUnreadCountManager(
                    (conversation.getUnreadCountManager() == null ? 0 : conversation.getUnreadCountManager()) + 1
            );
        }

        conversationRepository.save(conversation);

        // 1. tạo message
        ChatMessage message = ChatMessage.builder()
                .conversation(conversation)
                .sender(sender)
                .contentText(request.getContent())
                .createdAt(LocalDateTime.now())
                .build();

        chatMessageRepository.save(message);

        // 2. lưu ảnh nếu có
        if (request.getImages() != null && !request.getImages().isEmpty()){
            for (String url : request.getImages()) {
                ChatImage image = ChatImage.builder()
                        .chatMessage(message)
                        .imageUrl(url)
                        .build();

                chatImageRepository.save(image);
            }
        }

        return ChatResponse.builder()
                .chatId(message.getChatId())
                .senderId(sender.getUserId())
                .content(message.getContentText())
                .images(request.getImages())
                .createdAt(message.getCreatedAt())
                .build();
    }

    @Override
    public List<ChatResponse> getMessages(Long conversationId) {


        return chatMessageRepository

                .findByConversation_ConversationIdOrderByCreatedAtAsc(conversationId)
                .stream()
                .map(m -> {

                    List<String> images = chatImageRepository
                            .findByChatMessage_ChatId(m.getChatId())
                            .stream()
                            .map(ChatImage::getImageUrl)
                            .toList();

                    return ChatResponse.builder()
                            .chatId(m.getChatId())
                            .senderId(m.getSender().getUserId())
                            .content(m.getContentText())
                            .images(images)
                            .createdAt(m.getCreatedAt())
                            .build();
                })
                .toList();
    }

    @Override
    public List<String> uploadChatImages(List<MultipartFile> files) {

        List<String> urls = new ArrayList<>();

        for (MultipartFile file : files) {

            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();

            Path path = Paths.get(FileStorageConfig.CHAT_PATH + fileName);

            try {
                Files.write(path, file.getBytes());
            } catch (IOException e) {
                throw new RuntimeException("Upload lỗi");
            }

            urls.add("/images/chat/" + fileName);
        }

        return urls;
    }

    @Override
    public List<ConversationResponse> getUserConversations() {
        Long userId = SecurityUtil.getCurrentUserId();

        return conversationRepository.findByUser_UserId(userId)
                .stream()
                .filter(c -> chatMessageRepository
                        .existsByConversation_ConversationId(c.getConversationId()))
                .map(c -> {

                    HotelResponse hotel = hotelService.getHotelById(c.getHotel().getHotelId());

                    return ConversationResponse.builder()
                            .conversationId(c.getConversationId())
                            .hotelId(c.getHotel().getHotelId())
                            .hotelName(hotel.getHotelName())
                            .hotelImage(hotel.getMainImage())
                            .unreadCountUser(c.getUnreadCountUser()) //THÊM
                            .lastMessageAt(c.getLastMessageAt())
                            .build();
                })
                .sorted((a, b) -> {
                    if (a.getLastMessageAt() == null) return 1;
                    if (b.getLastMessageAt() == null) return -1;
                    return b.getLastMessageAt().compareTo(a.getLastMessageAt());
                })
                .toList();
    }

    @Override
    public List<ConversationResponse> getManagerConversations() {

        Long managerId = SecurityUtil.getCurrentUserId();

        // 1. lấy tất cả hotel của manager
        List<Hotel> hotels =
                hotelRepository.findByManager_UserIdAndIsDeletedFalse(managerId);

        List<ConversationResponse> result = new ArrayList<>();

        for (Hotel hotel : hotels) {

            // 2. lấy conversation của hotel đó
            List<Conversation> conversations =
                    conversationRepository.findByHotel_HotelId(hotel.getHotelId());

            // 3. nếu KHÔNG có conversation → vẫn thêm hotel
            if (conversations.isEmpty()) {
                HotelResponse hotelRes = hotelService.getHotelById(hotel.getHotelId());
                result.add(
                        ConversationResponse.builder()
                                .hotelId(hotel.getHotelId())
                                .hotelName(hotel.getHotelName())
                                .hotelImage(hotelRes.getMainImage())
                                .build()
                );

            } else {

                // 4. nếu có conversation → map như cũ
                for (Conversation c : conversations) {
                    HotelResponse hotelRes = hotelService.getHotelById(hotel.getHotelId());
                    result.add(
                            ConversationResponse.builder()
                                    .conversationId(c.getConversationId())
                                    .hotelId(hotel.getHotelId())
                                    .hotelName(hotel.getHotelName())
                                    .hotelImage(hotelRes.getMainImage())
                                    .userId(c.getUser().getUserId())
                                    .username(c.getUser().getUsername())
                                    .unreadCountManager(c.getUnreadCountManager())
                                    .lastMessageAt(c.getLastMessageAt())
                                    .build()
                    );
                }
            }
        }

        return result.stream()
                .sorted((a, b) -> {
                    if (a.getLastMessageAt() == null) return 1;
                    if (b.getLastMessageAt() == null) return -1;
                    return b.getLastMessageAt().compareTo(a.getLastMessageAt());
                })
                .toList();
    }

    @Override
    public void markAsRead(Long conversationId) {
        Long userId = SecurityUtil.getCurrentUserId();

        Conversation c = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("Not found"));

        if (userId.equals(c.getManager().getUserId())) {
            c.setUnreadCountManager(0);
        } else {
            c.setUnreadCountUser(0);
        }

        conversationRepository.save(c);
    }

    @Override
    public ConversationResponse getConversationInfo(Long conversationId) {

        Conversation c = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("Not found"));

        return ConversationResponse.builder()
                .conversationId(c.getConversationId())
                .managerId(c.getManager().getUserId())
                .userId(c.getUser().getUserId())
                .hotelId(c.getHotel().getHotelId())
                .build();
    }

}