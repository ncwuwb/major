package com.major.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import javax.validation.constraints.NotBlank;
import lombok.Data;

@Data
@Schema(description = "排行分析请求")
public class DashboardRankRequest {

    @NotBlank
    @Schema(description = "指标编码", example = "EMPLOYMENT_RATE")
    private String metric;

    @Schema(description = "学院ID", example = "1")
    private Integer deptId;

    @Schema(description = "专业ID，仅用于当前用户作用域约束", example = "1")
    private Integer majorId;

    @Schema(description = "统计年份", example = "2025")
    private Integer year;

    @Schema(description = "返回条数", example = "10")
    private Integer limit = 10;
}