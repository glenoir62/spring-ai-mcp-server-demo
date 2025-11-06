package com.adeo.demo.payment.backend.persistence;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    
    /**
     * Find all payments associated with a specific order ID
     * 
     * @param orderId The ID of the order
     * @return List of payments for the given order
     */
    List<Payment> findByOrderId(Long orderId);
}
