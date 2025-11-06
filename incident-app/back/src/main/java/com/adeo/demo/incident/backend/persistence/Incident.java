package com.adeo.demo.incident.backend.persistence;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Entity representing an incident in the system.
 */
@Entity
@Table(name = "incidents")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Incident {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "description", length = 1000)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "severity", nullable = false)
    private IncidentSeverity severity;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private IncidentStatus status;

    @Column(name = "reporter_name", nullable = false, length = 100)
    private String reporterName;    @Column(name = "assigned_to", length = 100)
    private String assignedTo;

    @Column(name = "resolution", length = 1000)
    private String resolution;

    @Column(name = "created_date", nullable = false)
    private LocalDate createdDate;

    @Column(name = "updated_date", nullable = false)
    private LocalDate updatedDate;
}
