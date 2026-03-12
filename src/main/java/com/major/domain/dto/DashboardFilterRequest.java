package com.major.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "仪表盘通用筛选条件")
public class DashboardFilterRequest {

    @Schema(description = "学院ID", example = "1")
    private Integer deptId;

    @Schema(description = "专业ID", example = "1")
    private Integer majorId;

    @Schema(description = "统计年份", example = "2025")
    private Integer year;
}