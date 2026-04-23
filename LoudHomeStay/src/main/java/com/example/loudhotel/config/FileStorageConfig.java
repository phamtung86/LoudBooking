package com.example.loudhotel.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class FileStorageConfig implements WebMvcConfigurer {

    public static final String ROOM_PATH = "D:/images_booking/room_images/";
    public static final String HOTEL_PATH = "D:/images_booking/hotel_images/";
    public static final String CHAT_PATH = "D:/images_booking/chat_images/";
    public static final String ROOM_TYPE_PATH = "D:/images_booking/room_type_images/";

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        registry.addResourceHandler("/images/rooms/**")
                .addResourceLocations("file:" + ROOM_PATH);

        registry.addResourceHandler("/images/hotels/**")
                .addResourceLocations("file:" + HOTEL_PATH);

        registry.addResourceHandler("/images/chat/**")
                .addResourceLocations("file:" + CHAT_PATH);

        registry.addResourceHandler("/images/room-types/**")
                .addResourceLocations("file:" + ROOM_TYPE_PATH);
    }
}
