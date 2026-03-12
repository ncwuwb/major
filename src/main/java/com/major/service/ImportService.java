package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.major.common.exception.BusinessException;
import com.major.domain.entity.AdmissionEntity;
import com.major.domain.entity.CourseEntity;
import com.major.domain.entity.FundingEntity;
import com.major.domain.entity.GraduateOutcomeEntity;
import com.major.domain.entity.ImportTaskEntity;
import com.major.domain.entity.StudentEntity;
import com.major.domain.entity.TeacherEntity;
import com.major.domain.vo.ImportResultVO;
import com.major.mapper.AdmissionMapper;
import com.major.mapper.FundingMapper;
import com.major.mapper.GraduateOutcomeMapper;
import com.major.mapper.ImportTaskMapper;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ImportService {

    private final ImportTaskMapper importTaskMapper;
    private final MasterDataService masterDataService;
    private final AnnualDataService annualDataService;
    private final AdmissionMapper admissionMapper;
    private final FundingMapper fundingMapper;
    private final GraduateOutcomeMapper graduateOutcomeMapper;

    public ImportService(ImportTaskMapper importTaskMapper, MasterDataService masterDataService,
                         AnnualDataService annualDataService, AdmissionMapper admissionMapper,
                         FundingMapper fundingMapper, GraduateOutcomeMapper graduateOutcomeMapper) {
        this.importTaskMapper = importTaskMapper;
        this.masterDataService = masterDataService;
        this.annualDataService = annualDataService;
        this.admissionMapper = admissionMapper;
        this.fundingMapper = fundingMapper;
        this.graduateOutcomeMapper = graduateOutcomeMapper;
    }

    public ImportResultVO importData(String type, MultipartFile file) {
        ImportTaskEntity task = new ImportTaskEntity();
        task.setTaskType(type);
        task.setFileName(file.getOriginalFilename());
        task.setStatus("RUNNING");
        task.setTotalRows(0);
        task.setSuccessRows(0);
        task.setFailRows(0);
        importTaskMapper.insert(task);

        List<Map<String, String>> rows;
        try {
            rows = readRows(file);
        } catch (IOException ex) {
            task.setStatus("FAILED");
            task.setErrorMessage(ex.getMessage());
            importTaskMapper.updateById(task);
            throw new BusinessException(400, "导入文件解析失败: " + ex.getMessage());
        }

        List<String> errors = new ArrayList<>();
        int successCount = 0;
        int rowIndex = 1;
        for (Map<String, String> row : rows) {
            rowIndex++;
            try {
                handleRow(type, row);
                successCount++;
            } catch (Exception ex) {
                errors.add("第" + rowIndex + "行: " + ex.getMessage());
            }
        }
        task.setTotalRows(rows.size());
        task.setSuccessRows(successCount);
        task.setFailRows(rows.size() - successCount);
        task.setStatus(errors.isEmpty() ? "SUCCESS" : (successCount > 0 ? "PARTIAL" : "FAILED"));
        task.setErrorMessage(errors.stream().limit(20).collect(Collectors.joining(" | ")));
        importTaskMapper.updateById(task);
        return new ImportResultVO(task.getTaskId(), task.getStatus(), task.getTotalRows(), task.getSuccessRows(),
                task.getFailRows(), task.getErrorMessage());
    }

    private void handleRow(String type, Map<String, String> row) {
        switch (type.toLowerCase(Locale.ROOT)) {
            case "teachers":
                TeacherEntity teacher = new TeacherEntity();
                teacher.setTeacherNo(required(row, "teacherNo", "教师工号"));
                teacher.setDeptId(requiredInt(row, "deptId", "学院ID"));
                teacher.setName(required(row, "name", "教师姓名"));
                teacher.setTitle(optional(row, "title", "职称"));
                teacher.setDegree(optional(row, "degree", "学位"));
                teacher.setPhdFlag(optionalInt(row, 0, "phdFlag", "是否博士"));
                teacher.setEmploymentType(optional(row, "employmentType", "聘用类型"));
                masterDataService.saveTeacher(teacher);
                break;
            case "students":
                StudentEntity student = new StudentEntity();
                student.setStudentNo(required(row, "studentNo", "学号"));
                student.setMajorId(requiredInt(row, "majorId", "专业ID"));
                student.setName(required(row, "name", "学生姓名"));
                student.setGender(optional(row, "gender", "性别"));
                student.setEnrollmentYear(optionalInt(row, null, "enrollmentYear", "入学年份"));
                student.setStatus(optional(row, "status", "状态"));
                masterDataService.saveStudent(student);
                break;
            case "courses":
                CourseEntity course = new CourseEntity();
                course.setCourseCode(required(row, "courseCode", "课程代码"));
                course.setMajorId(requiredInt(row, "majorId", "专业ID"));
                course.setName(required(row, "name", "课程名称"));
                course.setType(optional(row, "type", "课程类型"));
                String credits = optional(row, "credits", "学分");
                if (credits != null) {
                    course.setCredits(new BigDecimal(credits));
                }
                course.setSemester(optional(row, "semester", "开课学期"));
                masterDataService.saveCourse(course);
                break;
            case "admissions":
                AdmissionEntity admission = new AdmissionEntity();
                admission.setMajorId(requiredInt(row, "majorId", "专业ID"));
                admission.setStatYear(requiredInt(row, "statYear", "年份"));
                admission.setPlanCount(optionalInt(row, 0, "planCount", "计划人数"));
                admission.setActualCount(optionalInt(row, 0, "actualCount", "录取人数"));
                String minScore = optional(row, "minScore", "最低分");
                if (minScore != null) {
                    admission.setMinScore(new BigDecimal(minScore));
                }
                String maxScore = optional(row, "maxScore", "最高分");
                if (maxScore != null) {
                    admission.setMaxScore(new BigDecimal(maxScore));
                }
                AdmissionEntity admissionExist = admissionMapper.selectOne(new QueryWrapper<AdmissionEntity>()
                        .eq("major_id", admission.getMajorId()).eq("stat_year", admission.getStatYear()).eq("deleted", 0)
                        .last("limit 1"));
                if (admissionExist == null) {
                    annualDataService.saveAdmission(admission);
                } else {
                    annualDataService.updateAdmission(admissionExist.getAdmissionId(), admission);
                }
                break;
            case "fundings":
                FundingEntity funding = new FundingEntity();
                funding.setMajorId(requiredInt(row, "majorId", "专业ID"));
                funding.setStatYear(requiredInt(row, "statYear", "年份"));
                funding.setAllocated(new BigDecimal(required(row, "allocated", "分配经费")));
                funding.setSpent(new BigDecimal(required(row, "spent", "已使用经费")));
                String utilization = optional(row, "utilizationRate", "使用率");
                if (utilization != null) {
                    funding.setUtilizationRate(new BigDecimal(utilization));
                }
                FundingEntity fundingExist = fundingMapper.selectOne(new QueryWrapper<FundingEntity>()
                        .eq("major_id", funding.getMajorId()).eq("stat_year", funding.getStatYear()).eq("deleted", 0)
                        .last("limit 1"));
                if (fundingExist == null) {
                    annualDataService.saveFunding(funding);
                } else {
                    annualDataService.updateFunding(fundingExist.getFundingId(), funding);
                }
                break;
            case "graduate-outcomes":
                GraduateOutcomeEntity outcome = new GraduateOutcomeEntity();
                outcome.setMajorId(requiredInt(row, "majorId", "专业ID"));
                outcome.setStatYear(requiredInt(row, "statYear", "年份"));
                outcome.setGraduateCount(requiredInt(row, "graduateCount", "毕业人数"));
                outcome.setEmploymentRate(new BigDecimal(required(row, "employmentRate", "就业率")));
                outcome.setPostgraduateRate(new BigDecimal(required(row, "postgraduateRate", "升学率")));
                String salary = optional(row, "averageSalary", "平均薪资");
                if (salary != null) {
                    outcome.setAverageSalary(new BigDecimal(salary));
                }
                GraduateOutcomeEntity outcomeExist = graduateOutcomeMapper.selectOne(new QueryWrapper<GraduateOutcomeEntity>()
                        .eq("major_id", outcome.getMajorId()).eq("stat_year", outcome.getStatYear()).eq("deleted", 0)
                        .last("limit 1"));
                if (outcomeExist == null) {
                    annualDataService.saveGraduateOutcome(outcome);
                } else {
                    annualDataService.updateGraduateOutcome(outcomeExist.getOutcomeId(), outcome);
                }
                break;
            default:
                throw new BusinessException(400, "不支持的导入类型: " + type);
        }
    }

    private List<Map<String, String>> readRows(MultipartFile file) throws IOException {
        String name = file.getOriginalFilename() == null ? "" : file.getOriginalFilename().toLowerCase(Locale.ROOT);
        if (name.endsWith(".csv")) {
            return readCsv(file.getInputStream());
        }
        return readExcel(file.getInputStream());
    }

    private List<Map<String, String>> readCsv(InputStream inputStream) throws IOException {
        List<Map<String, String>> rows = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            String headerLine = reader.readLine();
            if (headerLine == null) {
                return rows;
            }
            String[] headers = headerLine.split(",");
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }
                String[] values = line.split(",", -1);
                Map<String, String> row = new LinkedHashMap<>();
                for (int i = 0; i < headers.length; i++) {
                    row.put(headers[i].trim(), i < values.length ? values[i].trim() : "");
                }
                rows.add(row);
            }
        }
        return rows;
    }

    private List<Map<String, String>> readExcel(InputStream inputStream) throws IOException {
        List<Map<String, String>> rows = new ArrayList<>();
        DataFormatter formatter = new DataFormatter();
        try (Workbook workbook = WorkbookFactory.create(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> iterator = sheet.iterator();
            if (!iterator.hasNext()) {
                return rows;
            }
            Row headerRow = iterator.next();
            List<String> headers = new ArrayList<>();
            for (Cell cell : headerRow) {
                headers.add(formatter.formatCellValue(cell).trim());
            }
            while (iterator.hasNext()) {
                Row rowData = iterator.next();
                Map<String, String> row = new LinkedHashMap<>();
                boolean hasValue = false;
                for (int i = 0; i < headers.size(); i++) {
                    Cell cell = rowData.getCell(i, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                    String value = formatter.formatCellValue(cell).trim();
                    if (!value.isEmpty()) {
                        hasValue = true;
                    }
                    row.put(headers.get(i), value);
                }
                if (hasValue) {
                    rows.add(row);
                }
            }
        } catch (Exception ex) {
            throw new IOException(ex.getMessage(), ex);
        }
        return rows;
    }

    private String required(Map<String, String> row, String... keys) {
        String value = optional(row, keys);
        if (value == null || value.trim().isEmpty()) {
            throw new BusinessException(400, "缺少必填列: " + keys[0]);
        }
        return value;
    }

    private Integer requiredInt(Map<String, String> row, String... keys) {
        return Integer.valueOf(required(row, keys));
    }

    private Integer optionalInt(Map<String, String> row, Integer defaultValue, String... keys) {
        String value = optional(row, keys);
        return value == null || value.isEmpty() ? defaultValue : Integer.valueOf(value);
    }

    private String optional(Map<String, String> row, String... keys) {
        for (String key : keys) {
            if (row.containsKey(key) && row.get(key) != null && !row.get(key).trim().isEmpty()) {
                return row.get(key).trim();
            }
        }
        return null;
    }
}
