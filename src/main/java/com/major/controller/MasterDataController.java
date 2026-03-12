package com.major.controller;

import com.major.annotation.OperationLog;
import com.major.common.model.PageQuery;
import com.major.common.response.ApiResponse;
import com.major.domain.entity.CourseEntity;
import com.major.domain.entity.ExperimentBaseEntity;
import com.major.domain.entity.StudentEntity;
import com.major.domain.entity.TeacherEntity;
import com.major.service.MasterDataService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springdoc.api.annotations.ParameterObject;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "教师管理", description = "教师主数据维护接口")
@Tag(name = "学生管理", description = "学生主数据维护接口")
@Tag(name = "课程管理", description = "课程主数据维护接口")
@Tag(name = "实验基地管理", description = "实验基地维护接口")
@Validated
@RestController
@RequestMapping("/api")
public class MasterDataController {

    private final MasterDataService masterDataService;

    public MasterDataController(MasterDataService masterDataService) {
        this.masterDataService = masterDataService;
    }

    @Operation(tags = { "教师管理" }, summary = "分页查询教师", description = "按关键字和学院范围分页查询教师数据。")
    @GetMapping("/teachers")
    public ApiResponse<?> teachers(@ParameterObject PageQuery pageQuery,
                                   @Parameter(description = "关键字，按教师姓名或工号模糊查询")
                                   @RequestParam(required = false) String keyword,
                                   @Parameter(description = "学院ID", example = "1")
                                   @RequestParam(required = false) Integer deptId) {
        return ApiResponse.success(masterDataService.pageTeachers(pageQuery, keyword, deptId));
    }

    @Operation(tags = { "教师管理" }, summary = "查询教师详情", description = "根据教师 ID 查询单条教师信息。")
    @GetMapping("/teachers/{id}")
    public ApiResponse<TeacherEntity> teacher(@Parameter(description = "教师ID", example = "1")
                                              @PathVariable Integer id) {
        return ApiResponse.success(masterDataService.getTeacher(id));
    }

    @Operation(tags = { "教师管理" }, summary = "创建教师", description = "新增教师数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PostMapping("/teachers")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "教师管理", action = "新增教师")
    public ApiResponse<Void> createTeacher(@RequestBody TeacherEntity entity) {
        masterDataService.saveTeacher(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "教师管理" }, summary = "更新教师", description = "修改教师数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PutMapping("/teachers/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "教师管理", action = "修改教师")
    public ApiResponse<Void> updateTeacher(@Parameter(description = "教师ID", example = "1")
                                           @PathVariable Integer id,
                                           @RequestBody TeacherEntity entity) {
        masterDataService.updateTeacher(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "教师管理" }, summary = "删除教师", description = "删除教师数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @DeleteMapping("/teachers/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "教师管理", action = "删除教师")
    public ApiResponse<Void> deleteTeacher(@Parameter(description = "教师ID", example = "1")
                                           @PathVariable Integer id) {
        masterDataService.deleteTeacher(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "学生管理" }, summary = "分页查询学生", description = "按关键字和专业范围分页查询学生数据。")
    @GetMapping("/students")
    public ApiResponse<?> students(@ParameterObject PageQuery pageQuery,
                                   @Parameter(description = "关键字，按学生姓名或学号模糊查询")
                                   @RequestParam(required = false) String keyword,
                                   @Parameter(description = "专业ID", example = "1")
                                   @RequestParam(required = false) Integer majorId) {
        return ApiResponse.success(masterDataService.pageStudents(pageQuery, keyword, majorId));
    }

    @Operation(tags = { "学生管理" }, summary = "查询学生详情", description = "根据学生 ID 查询单条学生信息。")
    @GetMapping("/students/{id}")
    public ApiResponse<StudentEntity> student(@Parameter(description = "学生ID", example = "1")
                                              @PathVariable Integer id) {
        return ApiResponse.success(masterDataService.getStudent(id));
    }

    @Operation(tags = { "学生管理" }, summary = "创建学生", description = "新增学生数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PostMapping("/students")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "学生管理", action = "新增学生")
    public ApiResponse<Void> createStudent(@RequestBody StudentEntity entity) {
        masterDataService.saveStudent(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "学生管理" }, summary = "更新学生", description = "修改学生数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PutMapping("/students/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "学生管理", action = "修改学生")
    public ApiResponse<Void> updateStudent(@Parameter(description = "学生ID", example = "1")
                                           @PathVariable Integer id,
                                           @RequestBody StudentEntity entity) {
        masterDataService.updateStudent(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "学生管理" }, summary = "删除学生", description = "删除学生数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @DeleteMapping("/students/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "学生管理", action = "删除学生")
    public ApiResponse<Void> deleteStudent(@Parameter(description = "学生ID", example = "1")
                                           @PathVariable Integer id) {
        masterDataService.deleteStudent(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "课程管理" }, summary = "分页查询课程", description = "按关键字和专业范围分页查询课程数据。")
    @GetMapping("/courses")
    public ApiResponse<?> courses(@ParameterObject PageQuery pageQuery,
                                  @Parameter(description = "关键字，按课程名称或课程代码模糊查询")
                                  @RequestParam(required = false) String keyword,
                                  @Parameter(description = "专业ID", example = "1")
                                  @RequestParam(required = false) Integer majorId) {
        return ApiResponse.success(masterDataService.pageCourses(pageQuery, keyword, majorId));
    }

    @Operation(tags = { "课程管理" }, summary = "查询课程详情", description = "根据课程 ID 查询单条课程信息。")
    @GetMapping("/courses/{id}")
    public ApiResponse<CourseEntity> course(@Parameter(description = "课程ID", example = "1")
                                            @PathVariable Integer id) {
        return ApiResponse.success(masterDataService.getCourse(id));
    }

    @Operation(tags = { "课程管理" }, summary = "创建课程", description = "新增课程数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PostMapping("/courses")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "课程管理", action = "新增课程")
    public ApiResponse<Void> createCourse(@RequestBody CourseEntity entity) {
        masterDataService.saveCourse(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "课程管理" }, summary = "更新课程", description = "修改课程数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PutMapping("/courses/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "课程管理", action = "修改课程")
    public ApiResponse<Void> updateCourse(@Parameter(description = "课程ID", example = "1")
                                          @PathVariable Integer id,
                                          @RequestBody CourseEntity entity) {
        masterDataService.updateCourse(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "课程管理" }, summary = "删除课程", description = "删除课程数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @DeleteMapping("/courses/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "课程管理", action = "删除课程")
    public ApiResponse<Void> deleteCourse(@Parameter(description = "课程ID", example = "1")
                                          @PathVariable Integer id) {
        masterDataService.deleteCourse(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "实验基地管理" }, summary = "分页查询实验基地", description = "按关键字和专业范围分页查询实验基地数据。")
    @GetMapping("/experiment-bases")
    public ApiResponse<?> experimentBases(@ParameterObject PageQuery pageQuery,
                                          @Parameter(description = "关键字，按基地名称模糊查询")
                                          @RequestParam(required = false) String keyword,
                                          @Parameter(description = "专业ID", example = "1")
                                          @RequestParam(required = false) Integer majorId) {
        return ApiResponse.success(masterDataService.pageExperimentBases(pageQuery, keyword, majorId));
    }

    @Operation(tags = { "实验基地管理" }, summary = "查询实验基地详情", description = "根据实验基地 ID 查询单条实验基地信息。")
    @GetMapping("/experiment-bases/{id}")
    public ApiResponse<ExperimentBaseEntity> experimentBase(@Parameter(description = "实验基地ID", example = "1")
                                                            @PathVariable Integer id) {
        return ApiResponse.success(masterDataService.getExperimentBase(id));
    }

    @Operation(tags = { "实验基地管理" }, summary = "创建实验基地", description = "新增实验基地数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PostMapping("/experiment-bases")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "实验基地管理", action = "新增实验基地")
    public ApiResponse<Void> createExperimentBase(@RequestBody ExperimentBaseEntity entity) {
        masterDataService.saveExperimentBase(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "实验基地管理" }, summary = "更新实验基地", description = "修改实验基地数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PutMapping("/experiment-bases/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "实验基地管理", action = "修改实验基地")
    public ApiResponse<Void> updateExperimentBase(@Parameter(description = "实验基地ID", example = "1")
                                                  @PathVariable Integer id,
                                                  @RequestBody ExperimentBaseEntity entity) {
        masterDataService.updateExperimentBase(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "实验基地管理" }, summary = "删除实验基地", description = "删除实验基地数据，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @DeleteMapping("/experiment-bases/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "实验基地管理", action = "删除实验基地")
    public ApiResponse<Void> deleteExperimentBase(@Parameter(description = "实验基地ID", example = "1")
                                                  @PathVariable Integer id) {
        masterDataService.deleteExperimentBase(id);
        return ApiResponse.success();
    }
}