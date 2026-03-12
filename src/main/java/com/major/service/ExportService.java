package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.major.domain.dto.DashboardFilterRequest;
import com.major.domain.dto.DashboardTrendRequest;
import com.major.domain.entity.AdmissionEntity;
import com.major.domain.entity.FundingEntity;
import com.major.domain.entity.GraduateOutcomeEntity;
import com.major.domain.vo.DashboardRankVO;
import com.major.domain.vo.DashboardScoreVO;
import com.major.domain.vo.DashboardTrendPointVO;
import com.major.domain.vo.WarningDetailVO;
import com.major.mapper.AdmissionMapper;
import com.major.mapper.FundingMapper;
import com.major.mapper.GraduateOutcomeMapper;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

@Service
public class ExportService {

    private final DashboardService dashboardService;
    private final AdmissionMapper admissionMapper;
    private final FundingMapper fundingMapper;
    private final GraduateOutcomeMapper graduateOutcomeMapper;
    private final DataScopeService dataScopeService;

    public ExportService(DashboardService dashboardService, AdmissionMapper admissionMapper, FundingMapper fundingMapper,
                         GraduateOutcomeMapper graduateOutcomeMapper, DataScopeService dataScopeService) {
        this.dashboardService = dashboardService;
        this.admissionMapper = admissionMapper;
        this.fundingMapper = fundingMapper;
        this.graduateOutcomeMapper = graduateOutcomeMapper;
        this.dataScopeService = dataScopeService;
    }

    public void exportMajorSummary(DashboardFilterRequest request, HttpServletResponse response) throws IOException {
        List<DashboardScoreVO> scores = dashboardService.score(request);
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("major-summary");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("专业ID");
            header.createCell(1).setCellValue("专业名称");
            header.createCell(2).setCellValue("博士占比");
            header.createCell(3).setCellValue("招生完成率");
            header.createCell(4).setCellValue("经费使用率");
            header.createCell(5).setCellValue("就业率");
            header.createCell(6).setCellValue("升学率");
            header.createCell(7).setCellValue("综合评分");
            int rowIndex = 1;
            for (DashboardScoreVO item : scores) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(item.getMajorId());
                row.createCell(1).setCellValue(item.getMajorName());
                row.createCell(2).setCellValue(value(item.getPhdRate()));
                row.createCell(3).setCellValue(value(item.getAdmissionCompletionRate()));
                row.createCell(4).setCellValue(value(item.getFundingUtilizationRate()));
                row.createCell(5).setCellValue(value(item.getEmploymentRate()));
                row.createCell(6).setCellValue(value(item.getPostgraduateRate()));
                row.createCell(7).setCellValue(value(item.getTotalScore()));
            }
            writeWorkbook(response, workbook, "major-summary.xlsx");
        }
    }

    public void exportWarningList(DashboardFilterRequest request, HttpServletResponse response) throws IOException {
        List<WarningDetailVO> warnings = dashboardService.warnings(request);
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("warning-list");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("预警ID");
            header.createCell(1).setCellValue("专业名称");
            header.createCell(2).setCellValue("指标名称");
            header.createCell(3).setCellValue("年份");
            header.createCell(4).setCellValue("阈值");
            header.createCell(5).setCellValue("实际值");
            header.createCell(6).setCellValue("状态");
            header.createCell(7).setCellValue("说明");
            int rowIndex = 1;
            for (WarningDetailVO item : warnings) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(item.getWarningId());
                row.createCell(1).setCellValue(item.getMajorName());
                row.createCell(2).setCellValue(item.getIndicatorName());
                row.createCell(3).setCellValue(item.getStatYear());
                row.createCell(4).setCellValue(value(item.getThresholdValue()));
                row.createCell(5).setCellValue(value(item.getActualValue()));
                row.createCell(6).setCellValue(item.getStatus());
                row.createCell(7).setCellValue(item.getMessage());
            }
            writeWorkbook(response, workbook, "warning-list.xlsx");
        }
    }

    public void exportAnnualIndicators(Integer deptId, Integer majorId, Integer startYear, Integer endYear,
                                       HttpServletResponse response) throws IOException {
        int actualEndYear = endYear == null ? java.time.LocalDate.now().getYear() : endYear;
        int actualStartYear = startYear == null ? actualEndYear - 4 : startYear;
        DashboardTrendRequest admissionTrend = new DashboardTrendRequest();
        admissionTrend.setMetric("ADMISSION_COMPLETION_RATE");
        admissionTrend.setDeptId(deptId);
        admissionTrend.setMajorId(majorId);
        admissionTrend.setStartYear(actualStartYear);
        admissionTrend.setEndYear(actualEndYear);
        DashboardTrendRequest fundingTrend = new DashboardTrendRequest();
        fundingTrend.setMetric("FUNDING_UTILIZATION_RATE");
        fundingTrend.setDeptId(deptId);
        fundingTrend.setMajorId(majorId);
        fundingTrend.setStartYear(actualStartYear);
        fundingTrend.setEndYear(actualEndYear);
        DashboardTrendRequest employmentTrend = new DashboardTrendRequest();
        employmentTrend.setMetric("EMPLOYMENT_RATE");
        employmentTrend.setDeptId(deptId);
        employmentTrend.setMajorId(majorId);
        employmentTrend.setStartYear(actualStartYear);
        employmentTrend.setEndYear(actualEndYear);
        try (Workbook workbook = new XSSFWorkbook()) {
            writeTrendSheet(workbook.createSheet("admission-rate"), dashboardService.trend(admissionTrend), "招生完成率");
            writeTrendSheet(workbook.createSheet("funding-rate"), dashboardService.trend(fundingTrend), "经费使用率");
            writeTrendSheet(workbook.createSheet("employment-rate"), dashboardService.trend(employmentTrend), "就业率");
            writeWorkbook(response, workbook, "annual-indicators.xlsx");
        }
    }

    private void writeTrendSheet(Sheet sheet, List<DashboardTrendPointVO> rows, String metricName) {
        Row header = sheet.createRow(0);
        header.createCell(0).setCellValue("年份");
        header.createCell(1).setCellValue(metricName);
        int rowIndex = 1;
        for (DashboardTrendPointVO item : rows) {
            Row row = sheet.createRow(rowIndex++);
            row.createCell(0).setCellValue(item.getStatYear());
            row.createCell(1).setCellValue(value(item.getMetricValue()));
        }
    }

    private void writeWorkbook(HttpServletResponse response, Workbook workbook, String fileName) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + URLEncoder.encode(fileName, "UTF-8"));
        workbook.write(response.getOutputStream());
    }

    private double value(java.math.BigDecimal value) {
        return value == null ? 0D : value.doubleValue();
    }
}
