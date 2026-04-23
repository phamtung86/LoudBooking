package com.example.loudhotel.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UtilitiesRequest {

    @NotBlank(message = "Tên tiện ích không được để trống")
    private String utilitiesName;
}
