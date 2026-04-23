package com.example.loudhotel.service;

import com.example.loudhotel.dto.request.UtilitiesRequest;
import com.example.loudhotel.dto.response.UtilitiesResponse;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface UtilitiesService {

    Page<UtilitiesResponse> getAllUtilities(String keyword, Pageable pageable);

    void create(UtilitiesRequest request);

    void update(Long id, UtilitiesRequest request);

    void deleteById(Long id);

}
