package com.major.controller;

import com.major.domain.dto.DashboardFilterRequest;
import com.major.service.ExportService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.io.IOException;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "数据导出", description = "专业汇总、预警清单、年度指标趋势和年度业务数据等 Excel 导出接口")
@RestController
@RequestMapping("/api/export")
public class ExportController {

    private final ExportService exportService;

    public ExportController(ExportService exportService) {
        this.exportService = exportService;
    }

    @Operation(summary = "导出专业汇总报表", description = "按学院、专业和年份筛选导出专业汇总 Excel。")
    @GetMapping("/major-summary")
    public void exportMajorSummary(@Parameter(description = "学院ID", example = "1")
                                   @RequestParam(required = false) Integer deptId,
                                   @Parameter(description = "专业ID", example = "1")
                                   @RequestParam(required = false) Integer majorId,
                                   @Parameter(description = "统计年份", example = "2025")
                                   @RequestParam(required = false) Integer year,
                                   @Parameter(hidden = true) HttpServletResponse response) throws IOException {
        DashboardFilterRequest request = new DashboardFilterRequest();
        request.setDeptId(deptId);
        request.setMajorId(majorId);
        request.setYear(year);
        exportService.exportMajorSummary(request, response);
    }

    @Operation(summary = "导出预警清单", description = "按学院、专业和年份筛选导出预警记录 Excel。")
    @GetMapping("/warning-list")
    public void exportWarningList(@Parameter(description = "学院ID", example = "1")
                                  @RequestParam(required = false) Integer deptId,
                                  @Parameter(description = "专业ID", example = "1")
                                  @RequestParam(required = false) Integer majorId,
                                  @Parameter(description = "统计年份", example = "2025")
                                  @RequestParam(required = false) Integer year,
                                  @Parameter(hidden = true) HttpServletResponse response) throws IOException {
        DashboardFilterRequest request = new DashboardFilterRequest();
        request.setDeptId(deptId);
        request.setMajorId(majorId);
        request.setYear(year);
        exportService.exportWarningList(request, response);
    }

    @Operation(summary = "导出年度指标趋势报表", description = "按学院、专业和年份区间导出年度指标趋势 Excel。")
    @GetMapping("/annual-indicators")
    public void exportAnnualIndicators(@Parameter(description = "学院ID", example = "1")
                                       @RequestParam(required = false) Integer deptId,
                                       @Parameter(description = "专业ID", example = "1")
                                       @RequestParam(required = false) Integer majorId,
                                       @Parameter(description = "开始年份", example = "2021")
                                       @RequestParam(required = false) Integer startYear,
                                       @Parameter(description = "结束年份", example = "2025")
                                       @RequestParam(required = false) Integer endYear,
                                       @Parameter(hidden = true) HttpServletResponse response) throws IOException {
        exportService.exportAnnualIndicators(deptId, majorId, startYear, endYear, response);
    }

    @Operation(summary = "导出年度业务数据", description = "按数据类型(admissions/fundings等)、学院、专业、教师、学生和年份筛选导出对应业务数据 Excel。")
    @GetMapping("/data")
    public void exportData(@Parameter(description = "数据类型: admissions | fundings | graduateOutcomes | achievements | competitions | internationalExchanges", example = "admissions")
                           @RequestParam String type,
                           @Parameter(description = "学院ID", example = "1")
                           @RequestParam(required = false) Integer deptId,
                           @Parameter(description = "专业ID", example = "1")
                           @RequestParam(required = false) Integer majorId,
                           @Parameter(description = "教师ID", example = "1")
                           @RequestParam(required = false) Integer teacherId,
                           @Parameter(description = "学生ID", example = "1")
                           @RequestParam(required = false) Integer studentId,
                           @Parameter(description = "统计年份", example = "2025")
                           @RequestParam(required = false) Integer year,
                           @Parameter(hidden = true) HttpServletResponse response) throws IOException {
        exportService.exportData(type, deptId, majorId, teacherId, studentId, year, response);
    }
}