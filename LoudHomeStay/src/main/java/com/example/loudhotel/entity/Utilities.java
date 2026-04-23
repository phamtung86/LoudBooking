package com.example.loudhotel.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "utilities")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Utilities {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long utilitiesId;

    @Column(nullable = false, unique = true)
    private String utilitiesName;

    @Builder.Default
    @Column(name = "is_deleted")
    private Boolean isDeleted = false;


}
