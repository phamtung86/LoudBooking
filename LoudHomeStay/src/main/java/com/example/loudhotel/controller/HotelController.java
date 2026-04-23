package com.example.loudhotel.controller;

import com.example.loudhotel.dto.request.HotelRequest;
import com.example.loudhotel.dto.response.HotelResponse;
import com.example.loudhotel.dto.response.ImageResponse;
import com.example.loudhotel.dto.response.UtilitiesResponse;
import com.example.loudhotel.service.HotelService;
import com.example.loudhotel.service.ImageService;
import com.example.loudhotel.service.UtilitiesHotelService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/hotels")
@RequiredArgsConstructor
public class HotelController {

    private final HotelService hotelService;
    private final ImageService imageService;
    private final UtilitiesHotelService utilitiesHotelService;

    // Hiển thị theo manager
    @GetMapping("/my")
    @PreAuthorize("hasAnyRole('MANAGER','ADMIN')")
    public List<HotelResponse> getMyHotels(){

        return hotelService.getMyHotels();

    }

    // CREATE -> chỉ MANAGER
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public HotelResponse create(@RequestBody HotelRequest request) {
        return hotelService.createHotel(request);
    }

    // UPDATE -> ADMIN + MANAGER
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    public HotelResponse update(
            @PathVariable Long id,
            @RequestBody HotelRequest request) {

        return hotelService.updateHotel(id, request);
    }

    // DELETE -> ADMIN + MANAGER
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public void delete(@PathVariable Long id) {
        hotelService.deleteHotel(id);
    }

    // PUBLIC
    @GetMapping("/{id}")
    public HotelResponse get(@PathVariable Long id) {
        return hotelService.getHotelById(id);
    }

    @GetMapping
    public List<HotelResponse> getAll() {
        return hotelService.getAll();
    }

    @GetMapping("/search")
    public ResponseEntity<List<HotelResponse>> search(
            @RequestParam String keyword) {
        return ResponseEntity.ok(hotelService.searchAll(keyword));
    }

    // IMAGE
    @PostMapping("/{id}/images")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    public ResponseEntity<List<ImageResponse>> uploadImages(
            @PathVariable Long id,
            @RequestParam("files") List<MultipartFile> files,
            @RequestParam Integer mainIndex) {

        return ResponseEntity.ok(
                imageService.uploadHotelImages(id, files, mainIndex)
        );
    }

    @PutMapping("/images/{imageId}/main")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    public void setMain(@PathVariable Long imageId) {
        imageService.setMainImage(imageId);
    }

    @DeleteMapping("/images/{imageId}")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    public void deleteImage(@PathVariable Long imageId) {
        imageService.deleteImage(imageId);
    }

    @GetMapping("/{id}/images")
    public List<ImageResponse> getImages(@PathVariable Long id) {
        return imageService.getImagesByHotel(id);
    }

    @GetMapping("/{id}/utilities")
    public List<UtilitiesResponse> getUtilitiesByHotel(@PathVariable Long id) {
        return utilitiesHotelService.getUtilitiesByHotelPublic(id);
    }

}