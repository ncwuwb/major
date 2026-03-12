package com.major.controller;

import com.major.common.response.ApiResponse;
import com.major.domain.dto.DashboardFilterRequest;
import com.major.domain.dto.DashboardRankRequest;
import com.major.domain.dto.DashboardTrendRequest;
import com.major.service.DashboardService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import javax.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "监测分析", description = "概览、趋势、排行和综合评分接口")
@Tag(name = "预警管理", description = "预警查询与重算接口")
@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    private final DashboardService dashboardService;

    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @Operation(tags = { "监测分析" }, summary = "获取监测概览", description = "返回当前数据范围下的核心概览指标。请求体可为空，空值时默认使用当前用户权限范围。")
    @PostMapping("/overview")
    public ApiResponse<?> overview(@RequestBody(required = false) DashboardFilterRequest request) {
        return ApiResponse.success(dashboardService.overview(request == null ? new DashboardFilterRequest() : request));
    }

    @Operation(tags = { "监测分析" }, summary = "获取趋势分析", description = "根据指标编码和年份区间返回趋势变化数据。")
    @PostMapping("/trend")
    public ApiResponse<?> trend(@Valid @RequestBody DashboardTrendRequest request) {
        return ApiResponse.success(dashboardService.trend(request));
    }

    @Operation(tags = { "监测分析" }, summary = "获取指标排行", description = "根据指标编码返回当前范围内的排行结果。")
    @PostMapping("/rank")
    public ApiResponse<?> rank(@Valid @RequestBody DashboardRankRequest request) {
        return ApiResponse.success(dashboardService.rank(request));
    }

    @Operation(tags = { "预警管理" }, summary = "查询预警列表", description = "返回当前筛选范围下的预警记录。请求体可为空，空值时默认使用当前用户权限范围。")
    @PostMapping("/warnings")
    public ApiResponse<?> warnings(@RequestBody(required = false) DashboardFilterRequest request) {
        return ApiResponse.success(dashboardService.warnings(request == null ? new DashboardFilterRequest() : request));
    }

    @Operation(tags = { "监测分析" }, summary = "计算综合评分", description = "返回综合评分结果和指标贡献。请求体可为空，空值时默认使用当前用户权限范围。")
    @PostMapping("/score")
    public ApiResponse<?> score(@RequestBody(required = false) DashboardFilterRequest request) {
        return ApiResponse.success(dashboardService.score(request == null ? new DashboardFilterRequest() : request));
    }

    @Operation(tags = { "预警管理" }, summary = "重算预警结果", description = "触发全量预警重算，仅 SCHOOL_ADMIN 可操作。")
    @PostMapping("/warnings/recalculate")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    public ApiResponse<Void> recalculateWarnings() {
        dashboardService.recalculateWarnings();
        return ApiResponse.success();
    }
}