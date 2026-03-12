package com.major.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import javax.validation.constraints.NotBlank;
import lombok.Data;

@Data
@Schema(description = "趋势分析请求")
public class DashboardTrendRequest {

    @NotBlank
    @Schema(description = "指标编码", example = "ADMISSION_COMPLETION_RATE")
    private String metric;

    @Schema(description = "学院ID", example = "1")
    private Integer deptId;

    @Schema(description = "专业ID", example = "1")
    private Integer majorId;

    @Schema(description = "开始年份", example = "2021")
    private Integer startYear;

    @Schema(description = "结束年份", example = "2025")
    private Integer endYear;
}