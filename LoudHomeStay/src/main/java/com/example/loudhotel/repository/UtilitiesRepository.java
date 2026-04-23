package com.example.loudhotel.repository;

import com.example.loudhotel.entity.Utilities;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UtilitiesRepository extends JpaRepository<Utilities, Long> {

    Optional<Utilities> findByUtilitiesNameAndIsDeletedFalse(String utilitiesName);

    boolean existsByUtilitiesNameAndIsDeletedFalse(String utilitiesName);

    Page<Utilities> findByIsDeletedFalse(Pageable pageable);

    Page<Utilities> findByUtilitiesNameContainingIgnoreCaseAndIsDeletedFalse(String utilitiesName, Pageable pageable);

    Optional<Utilities> findByUtilitiesIdAndIsDeletedFalse(Long id);


}