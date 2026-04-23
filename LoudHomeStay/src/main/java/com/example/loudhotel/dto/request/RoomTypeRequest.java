package com.example.loudhotel.dto.request;

import lombok.Data;

@Data
public class RoomTypeRequest {

    private String typeName;
    private Integer capacity;
    private Double price;
    private String description;

    private String bedType;
    private Integer bedCount;
    private Double area;
}