package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.major.domain.dto.DashboardFilterRequest;
import com.major.domain.dto.DashboardTrendRequest;
import com.major.domain.entity.AchievementEntity;
import com.major.domain.entity.AdmissionEntity;
import com.major.domain.entity.CompetitionEntity;
import com.major.domain.entity.FundingEntity;
import com.major.domain.entity.GraduateOutcomeEntity;
import com.major.domain.entity.InternationalExchangeEntity;
import com.major.domain.entity.MajorEntity;
import com.major.domain.entity.StudentEntity;
import com.major.domain.entity.TeacherEntity;
import com.major.domain.vo.DashboardRankVO;
import com.major.domain.vo.DashboardScoreVO;
import com.major.domain.vo.DashboardTrendPointVO;
import com.major.domain.vo.WarningDetailVO;
import com.major.mapper.AchievementMapper;
import com.major.mapper.AdmissionMapper;
import com.major.mapper.CompetitionMapper;
import com.major.mapper.FundingMapper;
import com.major.mapper.GraduateOutcomeMapper;
import com.major.mapper.InternationalExchangeMapper;
import com.major.mapper.MajorMapper;
import com.major.mapper.StudentMapper;
import com.major.mapper.TeacherMapper;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
    private final AchievementMapper achievementMapper;
    private final CompetitionMapper competitionMapper;
    private final InternationalExchangeMapper internationalExchangeMapper;
    private final MajorMapper majorMapper;
    private final TeacherMapper teacherMapper;
    private final StudentMapper studentMapper;
    private final DataScopeService dataScopeService;

    public ExportService(DashboardService dashboardService, AdmissionMapper admissionMapper, FundingMapper fundingMapper,
                         GraduateOutcomeMapper graduateOutcomeMapper, AchievementMapper achievementMapper,
                         CompetitionMapper competitionMapper, InternationalExchangeMapper internationalExchangeMapper,
                         MajorMapper majorMapper, TeacherMapper teacherMapper, StudentMapper studentMapper,
                         DataScopeService dataScopeService) {
        this.dashboardService = dashboardService;
        this.admissionMapper = admissionMapper;
        this.fundingMapper = fundingMapper;
        this.graduateOutcomeMapper = graduateOutcomeMapper;
        this.achievementMapper = achievementMapper;
        this.competitionMapper = competitionMapper;
        this.internationalExchangeMapper = internationalExchangeMapper;
        this.majorMapper = majorMapper;
        this.teacherMapper = teacherMapper;
        this.studentMapper = studentMapper;
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

    public void exportData(String type, Integer deptId, Integer majorId, Integer teacherId,
                           Integer studentId, Integer year, HttpServletResponse response) throws IOException {
        switch (type) {
            case "admissions":
                exportAdmissions(deptId, majorId, year, response);
                break;
            case "fundings":
                exportFundings(deptId, majorId, year, response);
                break;
            case "graduateOutcomes":
                exportGraduateOutcomes(deptId, majorId, year, response);
                break;
            case "achievements":
                exportAchievements(deptId, teacherId, year, response);
                break;
            case "competitions":
                exportCompetitions(deptId, studentId, year, response);
                break;
            case "internationalExchanges":
                exportInternationalExchanges(deptId, studentId, year, response);
                break;
            default:
                throw new IllegalArgumentException("不支持的导出类型: " + type);
        }
    }

    private void exportAdmissions(Integer deptId, Integer majorId, Integer year,
                                  HttpServletResponse response) throws IOException {
        QueryWrapper<AdmissionEntity> qw = new QueryWrapper<>();
        applyFilters(qw, "major_id", majorId, "stat_year", year);
        dataScopeService.applyMajorScope(qw, "major_id");
        List<AdmissionEntity> rows = admissionMapper.selectList(qw);
        Map<Integer, String> majorNames = buildMajorNameMap();
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("招生数据");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("专业名称");
            header.createCell(1).setCellValue("统计年份");
            header.createCell(2).setCellValue("计划招生数");
            header.createCell(3).setCellValue("实际招生数");
            header.createCell(4).setCellValue("最低分数");
            header.createCell(5).setCellValue("最高分数");
            int rowIndex = 1;
            for (AdmissionEntity item : rows) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(nameOrId(majorNames, item.getMajorId()));
                row.createCell(1).setCellValue(item.getStatYear());
                row.createCell(2).setCellValue(nullSafeInt(item.getPlanCount()));
                row.createCell(3).setCellValue(nullSafeInt(item.getActualCount()));
                row.createCell(4).setCellValue(value(item.getMinScore()));
                row.createCell(5).setCellValue(value(item.getMaxScore()));
            }
            writeWorkbook(response, workbook, "招生数据.xlsx");
        }
    }

    private void exportFundings(Integer deptId, Integer majorId, Integer year,
                                HttpServletResponse response) throws IOException {
        QueryWrapper<FundingEntity> qw = new QueryWrapper<>();
        applyFilters(qw, "major_id", majorId, "stat_year", year);
        dataScopeService.applyMajorScope(qw, "major_id");
        List<FundingEntity> rows = fundingMapper.selectList(qw);
        Map<Integer, String> majorNames = buildMajorNameMap();
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("经费数据");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("专业名称");
            header.createCell(1).setCellValue("统计年份");
            header.createCell(2).setCellValue("拨款金额");
            header.createCell(3).setCellValue("已支出金额");
            header.createCell(4).setCellValue("使用率");
            int rowIndex = 1;
            for (FundingEntity item : rows) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(nameOrId(majorNames, item.getMajorId()));
                row.createCell(1).setCellValue(item.getStatYear());
                row.createCell(2).setCellValue(value(item.getAllocated()));
                row.createCell(3).setCellValue(value(item.getSpent()));
                row.createCell(4).setCellValue(value(item.getUtilizationRate()));
            }
            writeWorkbook(response, workbook, "经费数据.xlsx");
        }
    }

    private void exportGraduateOutcomes(Integer deptId, Integer majorId, Integer year,
                                        HttpServletResponse response) throws IOException {
        QueryWrapper<GraduateOutcomeEntity> qw = new QueryWrapper<>();
        applyFilters(qw, "major_id", majorId, "stat_year", year);
        dataScopeService.applyMajorScope(qw, "major_id");
        List<GraduateOutcomeEntity> rows = graduateOutcomeMapper.selectList(qw);
        Map<Integer, String> majorNames = buildMajorNameMap();
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("毕业去向");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("专业名称");
            header.createCell(1).setCellValue("统计年份");
            header.createCell(2).setCellValue("毕业人数");
            header.createCell(3).setCellValue("就业率");
            header.createCell(4).setCellValue("升学率");
            header.createCell(5).setCellValue("平均薪资");
            int rowIndex = 1;
            for (GraduateOutcomeEntity item : rows) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(nameOrId(majorNames, item.getMajorId()));
                row.createCell(1).setCellValue(item.getStatYear());
                row.createCell(2).setCellValue(nullSafeInt(item.getGraduateCount()));
                row.createCell(3).setCellValue(value(item.getEmploymentRate()));
                row.createCell(4).setCellValue(value(item.getPostgraduateRate()));
                row.createCell(5).setCellValue(value(item.getAverageSalary()));
            }
            writeWorkbook(response, workbook, "毕业去向.xlsx");
        }
    }

    private void exportAchievements(Integer deptId, Integer teacherId, Integer year,
                                    HttpServletResponse response) throws IOException {
        QueryWrapper<AchievementEntity> qw = new QueryWrapper<>();
        if (teacherId != null) {
            qw.eq("teacher_id", teacherId);
        }
        if (year != null) {
            qw.eq("stat_year", year);
        }
        dataScopeService.applyDeptScope(qw, "teacher_id");
        List<AchievementEntity> rows = achievementMapper.selectList(qw);
        Map<Integer, String> teacherNames = buildTeacherNameMap();
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("成果数据");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("教师姓名");
            header.createCell(1).setCellValue("成果名称");
            header.createCell(2).setCellValue("成果类型");
            header.createCell(3).setCellValue("统计年份");
            header.createCell(4).setCellValue("成果数量");
            int rowIndex = 1;
            for (AchievementEntity item : rows) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(nameOrId(teacherNames, item.getTeacherId()));
                row.createCell(1).setCellValue(item.getName());
                row.createCell(2).setCellValue(item.getType());
                row.createCell(3).setCellValue(item.getStatYear());
                row.createCell(4).setCellValue(nullSafeInt(item.getUnitCount()));
            }
            writeWorkbook(response, workbook, "成果数据.xlsx");
        }
    }

    private void exportCompetitions(Integer deptId, Integer studentId, Integer year,
                                    HttpServletResponse response) throws IOException {
        QueryWrapper<CompetitionEntity> qw = new QueryWrapper<>();
        if (studentId != null) {
            qw.eq("student_id", studentId);
        }
        if (year != null) {
            qw.eq("stat_year", year);
        }
        dataScopeService.applyStudentScope(qw, "student_id");
        List<CompetitionEntity> rows = competitionMapper.selectList(qw);
        Map<Integer, String> studentNames = buildStudentNameMap();
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("竞赛数据");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("学生姓名");
            header.createCell(1).setCellValue("竞赛名称");
            header.createCell(2).setCellValue("竞赛级别");
            header.createCell(3).setCellValue("获奖情况");
            header.createCell(4).setCellValue("统计年份");
            int rowIndex = 1;
            for (CompetitionEntity item : rows) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(nameOrId(studentNames, item.getStudentId()));
                row.createCell(1).setCellValue(item.getName());
                row.createCell(2).setCellValue(item.getLevel());
                row.createCell(3).setCellValue(item.getAward());
                row.createCell(4).setCellValue(item.getStatYear());
            }
            writeWorkbook(response, workbook, "竞赛数据.xlsx");
        }
    }

    private void exportInternationalExchanges(Integer deptId, Integer studentId, Integer year,
                                              HttpServletResponse response) throws IOException {
        QueryWrapper<InternationalExchangeEntity> qw = new QueryWrapper<>();
        if (studentId != null) {
            qw.eq("student_id", studentId);
        }
        if (year != null) {
            qw.eq("stat_year", year);
        }
        dataScopeService.applyStudentScope(qw, "student_id");
        List<InternationalExchangeEntity> rows = internationalExchangeMapper.selectList(qw);
        Map<Integer, String> studentNames = buildStudentNameMap();
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("国际交流");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("学生姓名");
            header.createCell(1).setCellValue("项目名称");
            header.createCell(2).setCellValue("统计年份");
            header.createCell(3).setCellValue("项目成果");
            int rowIndex = 1;
            for (InternationalExchangeEntity item : rows) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(nameOrId(studentNames, item.getStudentId()));
                row.createCell(1).setCellValue(item.getProgram());
                row.createCell(2).setCellValue(item.getStatYear());
                row.createCell(3).setCellValue(item.getOutcome());
            }
            writeWorkbook(response, workbook, "国际交流.xlsx");
        }
    }

    private Map<Integer, String> buildMajorNameMap() {
        Map<Integer, String> map = new HashMap<>();
        List<MajorEntity> majors = majorMapper.selectList(null);
        for (MajorEntity m : majors) {
            map.put(m.getMajorId(), m.getName());
        }
        return map;
    }

    private Map<Integer, String> buildTeacherNameMap() {
        Map<Integer, String> map = new HashMap<>();
        List<TeacherEntity> teachers = teacherMapper.selectList(null);
        for (TeacherEntity t : teachers) {
            map.put(t.getTeacherId(), t.getName());
        }
        return map;
    }

    private Map<Integer, String> buildStudentNameMap() {
        Map<Integer, String> map = new HashMap<>();
        List<StudentEntity> students = studentMapper.selectList(null);
        for (StudentEntity s : students) {
            map.put(s.getStudentId(), s.getName());
        }
        return map;
    }

    private String nameOrId(Map<Integer, String> nameMap, Integer id) {
        if (id == null) {
            return "";
        }
        String name = nameMap.get(id);
        return name != null ? name : id.toString();
    }

    private void applyFilters(QueryWrapper<?> qw, String idField, Integer idValue,
                              String yearField, Integer yearValue) {
        if (idValue != null) {
            qw.eq(idField, idValue);
        }
        if (yearValue != null) {
            qw.eq(yearField, yearValue);
        }
    }

    private int nullSafeInt(Integer value) {
        return value == null ? 0 : value;
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
