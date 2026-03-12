package com.major.domain.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ImportResultVO {

    private Long taskId;
    private String status;
    private int totalRows;
    private int successRows;
    private int failRows;
    private String errorMessage;
}
