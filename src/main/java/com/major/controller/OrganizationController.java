package com.major.controller;

import com.major.annotation.OperationLog;
import com.major.common.model.PageQuery;
import com.major.common.response.ApiResponse;
import com.major.domain.entity.CampusEntity;
import com.major.domain.entity.DepartmentEntity;
import com.major.domain.entity.MajorEntity;
import com.major.domain.entity.SchoolEntity;
import com.major.domain.entity.SysUserEntity;
import com.major.service.OrganizationService;
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

@Tag(name = "学校管理", description = "学校基础信息维护接口")
@Tag(name = "校区管理", description = "校区基础配置维护接口")
@Tag(name = "学院管理", description = "学院和教学单位维护接口")
@Tag(name = "专业管理", description = "专业基础信息维护接口")
@Tag(name = "系统用户", description = "后台账号和数据权限范围维护接口")
@Validated
@RestController
@RequestMapping("/api")
public class OrganizationController {

    private final OrganizationService organizationService;

    public OrganizationController(OrganizationService organizationService) {
        this.organizationService = organizationService;
    }

    @Operation(tags = { "学校管理" }, summary = "分页查询学校", description = "按关键字分页查询学校基础信息。")
    @GetMapping("/schools")
    public ApiResponse<?> schools(@ParameterObject PageQuery pageQuery,
                                  @Parameter(description = "关键字，按学校名称模糊查询")
                                  @RequestParam(required = false) String keyword) {
        return ApiResponse.success(organizationService.pageSchools(pageQuery, keyword));
    }

    @Operation(tags = { "学校管理" }, summary = "查询学校详情", description = "根据学校 ID 查询单条学校信息。")
    @GetMapping("/schools/{id}")
    public ApiResponse<SchoolEntity> school(@Parameter(description = "学校ID", example = "1")
                                            @PathVariable Integer id) {
        return ApiResponse.success(organizationService.getSchool(id));
    }

    @Operation(tags = { "学校管理" }, summary = "创建学校", description = "新增学校信息，仅 SCHOOL_ADMIN 可操作。")
    @PostMapping("/schools")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "学校管理", action = "新增学校")
    public ApiResponse<Void> createSchool(@RequestBody SchoolEntity entity) {
        organizationService.saveSchool(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "学校管理" }, summary = "更新学校", description = "修改学校信息，仅 SCHOOL_ADMIN 可操作。")
    @PutMapping("/schools/{id}")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "学校管理", action = "修改学校")
    public ApiResponse<Void> updateSchool(@Parameter(description = "学校ID", example = "1")
                                          @PathVariable Integer id,
                                          @RequestBody SchoolEntity entity) {
        organizationService.updateSchool(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "学校管理" }, summary = "删除学校", description = "删除学校信息，仅 SCHOOL_ADMIN 可操作；存在下级数据时会拦截。")
    @DeleteMapping("/schools/{id}")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "学校管理", action = "删除学校")
    public ApiResponse<Void> deleteSchool(@Parameter(description = "学校ID", example = "1")
                                          @PathVariable Integer id) {
        organizationService.deleteSchool(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "校区管理" }, summary = "分页查询校区", description = "按关键字分页查询校区配置。")
    @GetMapping("/campuses")
    public ApiResponse<?> campuses(@ParameterObject PageQuery pageQuery,
                                   @Parameter(description = "关键字，按校区名称模糊查询")
                                   @RequestParam(required = false) String keyword) {
        return ApiResponse.success(organizationService.pageCampuses(pageQuery, keyword));
    }

    @Operation(tags = { "校区管理" }, summary = "查询校区详情", description = "根据校区 ID 查询单条校区信息。")
    @GetMapping("/campuses/{id}")
    public ApiResponse<CampusEntity> campus(@Parameter(description = "校区ID", example = "1")
                                            @PathVariable Integer id) {
        return ApiResponse.success(organizationService.getCampus(id));
    }

    @Operation(tags = { "校区管理" }, summary = "创建校区", description = "新增校区信息，仅 SCHOOL_ADMIN 可操作。")
    @PostMapping("/campuses")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "校区管理", action = "新增校区")
    public ApiResponse<Void> createCampus(@RequestBody CampusEntity entity) {
        organizationService.saveCampus(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "校区管理" }, summary = "更新校区", description = "修改校区信息，仅 SCHOOL_ADMIN 可操作。")
    @PutMapping("/campuses/{id}")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "校区管理", action = "修改校区")
    public ApiResponse<Void> updateCampus(@Parameter(description = "校区ID", example = "1")
                                          @PathVariable Integer id,
                                          @RequestBody CampusEntity entity) {
        organizationService.updateCampus(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "校区管理" }, summary = "删除校区", description = "删除校区信息，仅 SCHOOL_ADMIN 可操作；存在关联数据时会拦截。")
    @DeleteMapping("/campuses/{id}")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "校区管理", action = "删除校区")
    public ApiResponse<Void> deleteCampus(@Parameter(description = "校区ID", example = "1")
                                          @PathVariable Integer id) {
        organizationService.deleteCampus(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "学院管理" }, summary = "分页查询学院", description = "按关键字分页查询学院或教学单位。")
    @GetMapping("/departments")
    public ApiResponse<?> departments(@ParameterObject PageQuery pageQuery,
                                      @Parameter(description = "关键字，按学院名称或编码模糊查询")
                                      @RequestParam(required = false) String keyword) {
        return ApiResponse.success(organizationService.pageDepartments(pageQuery, keyword));
    }

    @Operation(tags = { "学院管理" }, summary = "查询学院详情", description = "根据学院 ID 查询单条学院信息。")
    @GetMapping("/departments/{id}")
    public ApiResponse<DepartmentEntity> department(@Parameter(description = "学院ID", example = "1")
                                                    @PathVariable Integer id) {
        return ApiResponse.success(organizationService.getDepartment(id));
    }

    @Operation(tags = { "学院管理" }, summary = "创建学院", description = "新增学院信息，仅 SCHOOL_ADMIN 可操作。")
    @PostMapping("/departments")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "学院管理", action = "新增学院")
    public ApiResponse<Void> createDepartment(@RequestBody DepartmentEntity entity) {
        organizationService.saveDepartment(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "学院管理" }, summary = "更新学院", description = "修改学院信息，仅 SCHOOL_ADMIN 可操作。")
    @PutMapping("/departments/{id}")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "学院管理", action = "修改学院")
    public ApiResponse<Void> updateDepartment(@Parameter(description = "学院ID", example = "1")
                                              @PathVariable Integer id,
                                              @RequestBody DepartmentEntity entity) {
        organizationService.updateDepartment(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "学院管理" }, summary = "删除学院", description = "删除学院信息，仅 SCHOOL_ADMIN 可操作；存在专业或用户数据时会拦截。")
    @DeleteMapping("/departments/{id}")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "学院管理", action = "删除学院")
    public ApiResponse<Void> deleteDepartment(@Parameter(description = "学院ID", example = "1")
                                              @PathVariable Integer id) {
        organizationService.deleteDepartment(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "专业管理" }, summary = "分页查询专业", description = "按关键字和学院 ID 分页查询专业信息。")
    @GetMapping("/majors")
    public ApiResponse<?> majors(@ParameterObject PageQuery pageQuery,
                                 @Parameter(description = "关键字，按专业名称或编码模糊查询")
                                 @RequestParam(required = false) String keyword,
                                 @Parameter(description = "学院ID", example = "1")
                                 @RequestParam(required = false) Integer deptId) {
        return ApiResponse.success(organizationService.pageMajors(pageQuery, keyword, deptId));
    }

    @Operation(tags = { "专业管理" }, summary = "查询专业详情", description = "根据专业 ID 查询单条专业信息。")
    @GetMapping("/majors/{id}")
    public ApiResponse<MajorEntity> major(@Parameter(description = "专业ID", example = "1")
                                          @PathVariable Integer id) {
        return ApiResponse.success(organizationService.getMajor(id));
    }

    @Operation(tags = { "专业管理" }, summary = "创建专业", description = "新增专业信息，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PostMapping("/majors")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "专业管理", action = "新增专业")
    public ApiResponse<Void> createMajor(@RequestBody MajorEntity entity) {
        organizationService.saveMajor(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "专业管理" }, summary = "更新专业", description = "修改专业信息，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PutMapping("/majors/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "专业管理", action = "修改专业")
    public ApiResponse<Void> updateMajor(@Parameter(description = "专业ID", example = "1")
                                         @PathVariable Integer id,
                                         @RequestBody MajorEntity entity) {
        organizationService.updateMajor(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "专业管理" }, summary = "删除专业", description = "删除专业信息，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作；存在下游业务数据时会拦截。")
    @DeleteMapping("/majors/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "专业管理", action = "删除专业")
    public ApiResponse<Void> deleteMajor(@Parameter(description = "专业ID", example = "1")
                                         @PathVariable Integer id) {
        organizationService.deleteMajor(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "系统用户" }, summary = "分页查询系统用户", description = "分页查询后台账号，仅 SCHOOL_ADMIN 可查看。")
    @GetMapping("/users")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    public ApiResponse<?> users(@ParameterObject PageQuery pageQuery,
                                @Parameter(description = "关键字，按用户名或姓名模糊查询")
                                @RequestParam(required = false) String keyword) {
        return ApiResponse.success(organizationService.pageUsers(pageQuery, keyword));
    }

    @Operation(tags = { "系统用户" }, summary = "查询系统用户详情", description = "根据用户 ID 查询单条后台账号信息，仅 SCHOOL_ADMIN 可查看。")
    @GetMapping("/users/{id}")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    public ApiResponse<SysUserEntity> user(@Parameter(description = "用户ID", example = "1")
                                           @PathVariable Long id) {
        return ApiResponse.success(organizationService.getUser(id));
    }

    @Operation(tags = { "系统用户" }, summary = "创建系统用户", description = "新增后台账号，仅 SCHOOL_ADMIN 可操作。")
    @PostMapping("/users")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "用户管理", action = "新增用户")
    public ApiResponse<Void> createUser(@RequestBody SysUserEntity entity) {
        organizationService.saveUser(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "系统用户" }, summary = "更新系统用户", description = "修改后台账号，仅 SCHOOL_ADMIN 可操作。")
    @PutMapping("/users/{id}")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "用户管理", action = "修改用户")
    public ApiResponse<Void> updateUser(@Parameter(description = "用户ID", example = "1")
                                        @PathVariable Long id,
                                        @RequestBody SysUserEntity entity) {
        organizationService.updateUser(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "系统用户" }, summary = "删除系统用户", description = "删除后台账号，仅 SCHOOL_ADMIN 可操作。")
    @DeleteMapping("/users/{id}")
    @PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
    @OperationLog(module = "用户管理", action = "删除用户")
    public ApiResponse<Void> deleteUser(@Parameter(description = "用户ID", example = "1")
                                        @PathVariable Long id) {
        organizationService.deleteUser(id);
        return ApiResponse.success();
    }
}