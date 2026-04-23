package com.example.loudhotel.controller;


import com.example.loudhotel.dto.request.RoomTypeRequest;
import com.example.loudhotel.dto.response.ImageResponse;
import com.example.loudhotel.dto.response.RoomTypeResponse;
import com.example.loudhotel.entity.User;
import com.example.loudhotel.repository.UserRepository;
import com.example.loudhotel.service.ImageService;
import com.example.loudhotel.service.RoomTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;


@RestController
@RequestMapping("/api/room-types")
@RequiredArgsConstructor
public class RoomTypeController {

    private final RoomTypeService roomTypeService;
    private final ImageService imageService;
    private final UserRepository userRepository;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public List<RoomTypeResponse> getAll() {
        return roomTypeService.getAll();
    }

    @GetMapping("/{id}")
    public RoomTypeResponse getById(@PathVariable Long id) {
        return roomTypeService.getById(id);
    }

    @PostMapping("/hotel/{hotelId}")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    public RoomTypeResponse create(
            @PathVariable Long hotelId,
            @RequestBody RoomTypeRequest request
    ) {
        return roomTypeService.create(hotelId, request);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    public RoomTypeResponse update(@PathVariable Long id,
                         @RequestBody RoomTypeRequest request) {
        return roomTypeService.update(id, request);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    public void delete(@PathVariable Long id) {
        roomTypeService.delete(id);
    }

    @GetMapping("/hotel/{hotelId}")
    public List<RoomTypeResponse> getByHotel(@PathVariable Long hotelId) {
        return roomTypeService.getByHotel(hotelId);
    }

    @PostMapping("/{typeId}/images")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    public ResponseEntity<List<ImageResponse>> upload(
            @PathVariable Long typeId,
            @RequestParam("files") List<MultipartFile> files,
            @RequestParam Integer mainIndex) {

        return ResponseEntity.ok(
                imageService.uploadRoomTypeImages(typeId, files, mainIndex)
        );
    }

    @GetMapping("/{typeId}/images")
    public List<ImageResponse> getImages(@PathVariable Long typeId) {
        return imageService.getImagesByRoomType(typeId);
    }

    @PutMapping("/images/{imageId}/main")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    public void setMain(@PathVariable Long imageId) {
        imageService.setMainRoomTypeImage(imageId);
    }

    @DeleteMapping("/images/{imageId}")
    public void deleteImage(@PathVariable Long imageId) {
        imageService.deleteRoomTypeImage(imageId);
    }

    @GetMapping("/my")
    @PreAuthorize("hasRole('MANAGER')")
    public List<RoomTypeResponse> getMyRoomTypes(Authentication authentication) {

        String email = authentication.getName();

        User user = userRepository
                .findByEmailAndIsDeletedFalse(email)
                .orElseThrow();

        return roomTypeService.getRoomTypesByManager(user.getUserId());
    }
}