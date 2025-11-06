package com.adeo.demo.incident.backend.web.dto;

import com.adeo.demo.incident.backend.persistence.IncidentSeverity;
import com.adeo.demo.incident.backend.persistence.IncidentStatus;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object for Incident entity.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class IncidentDto {
    
    private Long id;
    private String title;
    private String description;
    private IncidentSeverity severity;
    private IncidentStatus status;    private String reporterName;
    private String assignedTo;
    private String resolution;
    private LocalDate createdDate;
    private LocalDate updatedDate;
}
