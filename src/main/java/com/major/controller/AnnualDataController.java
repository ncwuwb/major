package com.major.controller;

import com.major.annotation.OperationLog;
import com.major.common.model.PageQuery;
import com.major.common.response.ApiResponse;
import com.major.domain.entity.AchievementEntity;
import com.major.domain.entity.AdmissionEntity;
import com.major.domain.entity.CompetitionEntity;
import com.major.domain.entity.FundingEntity;
import com.major.domain.entity.GraduateOutcomeEntity;
import com.major.domain.entity.InternationalExchangeEntity;
import com.major.service.AnnualDataService;
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

@Tag(name = "招生数据", description = "年度招生计划与完成情况接口")
@Tag(name = "经费数据", description = "年度经费预算与使用情况接口")
@Tag(name = "毕业去向", description = "毕业生就业、升学和薪资数据接口")
@Tag(name = "成果数据", description = "科研与教学成果接口")
@Tag(name = "竞赛数据", description = "学生竞赛与获奖记录接口")
@Tag(name = "国际交流", description = "国际交流项目与参与记录接口")
@Validated
@RestController
@RequestMapping("/api")
public class AnnualDataController {

    private final AnnualDataService annualDataService;

    public AnnualDataController(AnnualDataService annualDataService) {
        this.annualDataService = annualDataService;
    }

    @Operation(tags = { "招生数据" }, summary = "分页查询招生记录", description = "按专业和年份分页查询招生计划与完成情况。")
    @GetMapping("/admissions")
    public ApiResponse<?> admissions(@ParameterObject PageQuery pageQuery,
                                     @Parameter(description = "专业ID", example = "1")
                                     @RequestParam(required = false) Integer majorId,
                                     @Parameter(description = "统计年份", example = "2025")
                                     @RequestParam(required = false) Integer year) {
        return ApiResponse.success(annualDataService.pageAdmissions(pageQuery, majorId, year));
    }

    @Operation(tags = { "招生数据" }, summary = "查询招生记录详情", description = "根据记录 ID 查询单条招生记录。")
    @GetMapping("/admissions/{id}")
    public ApiResponse<AdmissionEntity> admission(@Parameter(description = "招生记录ID", example = "1")
                                                  @PathVariable Integer id) {
        return ApiResponse.success(annualDataService.getAdmission(id));
    }

    @Operation(tags = { "招生数据" }, summary = "创建招生记录", description = "新增年度招生记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PostMapping("/admissions")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "招生管理", action = "新增招生记录")
    public ApiResponse<Void> createAdmission(@RequestBody AdmissionEntity entity) {
        annualDataService.saveAdmission(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "招生数据" }, summary = "更新招生记录", description = "修改年度招生记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PutMapping("/admissions/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "招生管理", action = "修改招生记录")
    public ApiResponse<Void> updateAdmission(@Parameter(description = "招生记录ID", example = "1")
                                             @PathVariable Integer id,
                                             @RequestBody AdmissionEntity entity) {
        annualDataService.updateAdmission(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "招生数据" }, summary = "删除招生记录", description = "删除年度招生记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @DeleteMapping("/admissions/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "招生管理", action = "删除招生记录")
    public ApiResponse<Void> deleteAdmission(@Parameter(description = "招生记录ID", example = "1")
                                             @PathVariable Integer id) {
        annualDataService.deleteAdmission(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "经费数据" }, summary = "分页查询经费记录", description = "按专业和年份分页查询经费预算与使用情况。")
    @GetMapping("/fundings")
    public ApiResponse<?> fundings(@ParameterObject PageQuery pageQuery,
                                   @Parameter(description = "专业ID", example = "1")
                                   @RequestParam(required = false) Integer majorId,
                                   @Parameter(description = "统计年份", example = "2025")
                                   @RequestParam(required = false) Integer year) {
        return ApiResponse.success(annualDataService.pageFundings(pageQuery, majorId, year));
    }

    @Operation(tags = { "经费数据" }, summary = "查询经费记录详情", description = "根据记录 ID 查询单条经费记录。")
    @GetMapping("/fundings/{id}")
    public ApiResponse<FundingEntity> funding(@Parameter(description = "经费记录ID", example = "1")
                                              @PathVariable Integer id) {
        return ApiResponse.success(annualDataService.getFunding(id));
    }

    @Operation(tags = { "经费数据" }, summary = "创建经费记录", description = "新增年度经费记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PostMapping("/fundings")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "经费管理", action = "新增经费记录")
    public ApiResponse<Void> createFunding(@RequestBody FundingEntity entity) {
        annualDataService.saveFunding(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "经费数据" }, summary = "更新经费记录", description = "修改年度经费记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PutMapping("/fundings/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "经费管理", action = "修改经费记录")
    public ApiResponse<Void> updateFunding(@Parameter(description = "经费记录ID", example = "1")
                                           @PathVariable Integer id,
                                           @RequestBody FundingEntity entity) {
        annualDataService.updateFunding(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "经费数据" }, summary = "删除经费记录", description = "删除年度经费记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @DeleteMapping("/fundings/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "经费管理", action = "删除经费记录")
    public ApiResponse<Void> deleteFunding(@Parameter(description = "经费记录ID", example = "1")
                                           @PathVariable Integer id) {
        annualDataService.deleteFunding(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "毕业去向" }, summary = "分页查询毕业去向", description = "按专业和年份分页查询就业率、升学率和平均薪资等数据。")
    @GetMapping("/graduate-outcomes")
    public ApiResponse<?> graduateOutcomes(@ParameterObject PageQuery pageQuery,
                                           @Parameter(description = "专业ID", example = "1")
                                           @RequestParam(required = false) Integer majorId,
                                           @Parameter(description = "统计年份", example = "2025")
                                           @RequestParam(required = false) Integer year) {
        return ApiResponse.success(annualDataService.pageGraduateOutcomes(pageQuery, majorId, year));
    }

    @Operation(tags = { "毕业去向" }, summary = "查询毕业去向详情", description = "根据记录 ID 查询单条毕业去向记录。")
    @GetMapping("/graduate-outcomes/{id}")
    public ApiResponse<GraduateOutcomeEntity> graduateOutcome(
            @Parameter(description = "毕业去向记录ID", example = "1") @PathVariable Integer id) {
        return ApiResponse.success(annualDataService.getGraduateOutcome(id));
    }

    @Operation(tags = { "毕业去向" }, summary = "创建毕业去向记录", description = "新增年度毕业去向记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PostMapping("/graduate-outcomes")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "毕业去向管理", action = "新增毕业去向")
    public ApiResponse<Void> createGraduateOutcome(@RequestBody GraduateOutcomeEntity entity) {
        annualDataService.saveGraduateOutcome(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "毕业去向" }, summary = "更新毕业去向记录", description = "修改年度毕业去向记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PutMapping("/graduate-outcomes/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "毕业去向管理", action = "修改毕业去向")
    public ApiResponse<Void> updateGraduateOutcome(
            @Parameter(description = "毕业去向记录ID", example = "1") @PathVariable Integer id,
            @RequestBody GraduateOutcomeEntity entity) {
        annualDataService.updateGraduateOutcome(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "毕业去向" }, summary = "删除毕业去向记录", description = "删除年度毕业去向记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @DeleteMapping("/graduate-outcomes/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "毕业去向管理", action = "删除毕业去向")
    public ApiResponse<Void> deleteGraduateOutcome(
            @Parameter(description = "毕业去向记录ID", example = "1") @PathVariable Integer id) {
        annualDataService.deleteGraduateOutcome(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "成果数据" }, summary = "分页查询成果", description = "按教师、年份和关键字分页查询科研或教学成果。")
    @GetMapping("/achievements")
    public ApiResponse<?> achievements(@ParameterObject PageQuery pageQuery,
                                       @Parameter(description = "教师ID", example = "1")
                                       @RequestParam(required = false) Integer teacherId,
                                       @Parameter(description = "统计年份", example = "2025")
                                       @RequestParam(required = false) Integer year,
                                       @Parameter(description = "关键字，按成果名称模糊查询")
                                       @RequestParam(required = false) String keyword) {
        return ApiResponse.success(annualDataService.pageAchievements(pageQuery, teacherId, year, keyword));
    }

    @Operation(tags = { "成果数据" }, summary = "查询成果详情", description = "根据记录 ID 查询单条成果记录。")
    @GetMapping("/achievements/{id}")
    public ApiResponse<AchievementEntity> achievement(@Parameter(description = "成果记录ID", example = "1")
                                                      @PathVariable Integer id) {
        return ApiResponse.success(annualDataService.getAchievement(id));
    }

    @Operation(tags = { "成果数据" }, summary = "创建成果记录", description = "新增成果记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PostMapping("/achievements")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "成果管理", action = "新增成果")
    public ApiResponse<Void> createAchievement(@RequestBody AchievementEntity entity) {
        annualDataService.saveAchievement(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "成果数据" }, summary = "更新成果记录", description = "修改成果记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PutMapping("/achievements/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "成果管理", action = "修改成果")
    public ApiResponse<Void> updateAchievement(@Parameter(description = "成果记录ID", example = "1")
                                               @PathVariable Integer id,
                                               @RequestBody AchievementEntity entity) {
        annualDataService.updateAchievement(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "成果数据" }, summary = "删除成果记录", description = "删除成果记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @DeleteMapping("/achievements/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "成果管理", action = "删除成果")
    public ApiResponse<Void> deleteAchievement(@Parameter(description = "成果记录ID", example = "1")
                                               @PathVariable Integer id) {
        annualDataService.deleteAchievement(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "竞赛数据" }, summary = "分页查询竞赛记录", description = "按学生、年份和关键字分页查询竞赛获奖记录。")
    @GetMapping("/competitions")
    public ApiResponse<?> competitions(@ParameterObject PageQuery pageQuery,
                                       @Parameter(description = "学生ID", example = "1")
                                       @RequestParam(required = false) Integer studentId,
                                       @Parameter(description = "统计年份", example = "2025")
                                       @RequestParam(required = false) Integer year,
                                       @Parameter(description = "关键字，按竞赛名称模糊查询")
                                       @RequestParam(required = false) String keyword) {
        return ApiResponse.success(annualDataService.pageCompetitions(pageQuery, studentId, year, keyword));
    }

    @Operation(tags = { "竞赛数据" }, summary = "查询竞赛记录详情", description = "根据记录 ID 查询单条竞赛记录。")
    @GetMapping("/competitions/{id}")
    public ApiResponse<CompetitionEntity> competition(@Parameter(description = "竞赛记录ID", example = "1")
                                                      @PathVariable Integer id) {
        return ApiResponse.success(annualDataService.getCompetition(id));
    }

    @Operation(tags = { "竞赛数据" }, summary = "创建竞赛记录", description = "新增竞赛记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PostMapping("/competitions")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "竞赛管理", action = "新增竞赛记录")
    public ApiResponse<Void> createCompetition(@RequestBody CompetitionEntity entity) {
        annualDataService.saveCompetition(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "竞赛数据" }, summary = "更新竞赛记录", description = "修改竞赛记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PutMapping("/competitions/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "竞赛管理", action = "修改竞赛记录")
    public ApiResponse<Void> updateCompetition(@Parameter(description = "竞赛记录ID", example = "1")
                                               @PathVariable Integer id,
                                               @RequestBody CompetitionEntity entity) {
        annualDataService.updateCompetition(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "竞赛数据" }, summary = "删除竞赛记录", description = "删除竞赛记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @DeleteMapping("/competitions/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "竞赛管理", action = "删除竞赛记录")
    public ApiResponse<Void> deleteCompetition(@Parameter(description = "竞赛记录ID", example = "1")
                                               @PathVariable Integer id) {
        annualDataService.deleteCompetition(id);
        return ApiResponse.success();
    }

    @Operation(tags = { "国际交流" }, summary = "分页查询国际交流记录", description = "按学生、年份和关键字分页查询国际交流项目记录。")
    @GetMapping("/international-exchanges")
    public ApiResponse<?> internationalExchanges(@ParameterObject PageQuery pageQuery,
                                                 @Parameter(description = "学生ID", example = "1")
                                                 @RequestParam(required = false) Integer studentId,
                                                 @Parameter(description = "统计年份", example = "2025")
                                                 @RequestParam(required = false) Integer year,
                                                 @Parameter(description = "关键字，按项目名称模糊查询")
                                                 @RequestParam(required = false) String keyword) {
        return ApiResponse.success(annualDataService.pageInternationalExchanges(pageQuery, studentId, year, keyword));
    }

    @Operation(tags = { "国际交流" }, summary = "查询国际交流记录详情", description = "根据记录 ID 查询单条国际交流记录。")
    @GetMapping("/international-exchanges/{id}")
    public ApiResponse<InternationalExchangeEntity> internationalExchange(
            @Parameter(description = "国际交流记录ID", example = "1") @PathVariable Integer id) {
        return ApiResponse.success(annualDataService.getInternationalExchange(id));
    }

    @Operation(tags = { "国际交流" }, summary = "创建国际交流记录", description = "新增国际交流记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PostMapping("/international-exchanges")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "国际交流管理", action = "新增国际交流记录")
    public ApiResponse<Void> createInternationalExchange(@RequestBody InternationalExchangeEntity entity) {
        annualDataService.saveInternationalExchange(entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "国际交流" }, summary = "更新国际交流记录", description = "修改国际交流记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @PutMapping("/international-exchanges/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "国际交流管理", action = "修改国际交流记录")
    public ApiResponse<Void> updateInternationalExchange(
            @Parameter(description = "国际交流记录ID", example = "1") @PathVariable Integer id,
            @RequestBody InternationalExchangeEntity entity) {
        annualDataService.updateInternationalExchange(id, entity);
        return ApiResponse.success();
    }

    @Operation(tags = { "国际交流" }, summary = "删除国际交流记录", description = "删除国际交流记录，SCHOOL_ADMIN 和 DEPT_ADMIN 可操作。")
    @DeleteMapping("/international-exchanges/{id}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    @OperationLog(module = "国际交流管理", action = "删除国际交流记录")
    public ApiResponse<Void> deleteInternationalExchange(
            @Parameter(description = "国际交流记录ID", example = "1") @PathVariable Integer id) {
        annualDataService.deleteInternationalExchange(id);
        return ApiResponse.success();
    }
}