package com.major.controller;

import com.major.annotation.OperationLog;
import com.major.common.model.PageQuery;
import com.major.common.response.ApiResponse;
import com.major.domain.entity.IndicatorRuleEntity;
import com.major.service.SystemConfigService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springdoc.api.annotations.ParameterObject;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "指标规则配置", description = "综合评分权重和预警阈值规则维护接口")
@RestController
@RequestMapping("/api/indicator-rules")
@PreAuthorize("hasAuthority('SCHOOL_ADMIN')")
public class SystemConfigController {

    private final SystemConfigService systemConfigService;

    public SystemConfigController(SystemConfigService systemConfigService) {
        this.systemConfigService = systemConfigService;
    }

    @Operation(summary = "分页查询指标规则", description = "分页查询综合评分权重和预警阈值规则，仅 SCHOOL_ADMIN 可查看。")
    @GetMapping
    public ApiResponse<?> list(@ParameterObject PageQuery pageQuery,
                               @Parameter(description = "关键字，按指标名称或编码模糊查询")
                               @RequestParam(required = false) String keyword) {
        return ApiResponse.success(systemConfigService.pageIndicatorRules(pageQuery, keyword));
    }

    @Operation(summary = "查询指标规则详情", description = "根据规则 ID 查询单条指标规则，仅 SCHOOL_ADMIN 可查看。")
    @GetMapping("/{id}")
    public ApiResponse<IndicatorRuleEntity> detail(@Parameter(description = "指标规则ID", example = "1")
                                                   @PathVariable Integer id) {
        return ApiResponse.success(systemConfigService.getIndicatorRule(id));
    }

    @Operation(summary = "创建指标规则", description = "新增综合评分权重或预警阈值规则，仅 SCHOOL_ADMIN 可操作。")
    @PostMapping
    @OperationLog(module = "指标规则", action = "新增指标规则")
    public ApiResponse<Void> create(@RequestBody IndicatorRuleEntity entity) {
        systemConfigService.saveIndicatorRule(entity);
        return ApiResponse.success();
    }

    @Operation(summary = "更新指标规则", description = "修改综合评分权重或预警阈值规则，仅 SCHOOL_ADMIN 可操作。")
    @PutMapping("/{id}")
    @OperationLog(module = "指标规则", action = "修改指标规则")
    public ApiResponse<Void> update(@Parameter(description = "指标规则ID", example = "1")
                                    @PathVariable Integer id,
                                    @RequestBody IndicatorRuleEntity entity) {
        systemConfigService.updateIndicatorRule(id, entity);
        return ApiResponse.success();
    }

    @Operation(summary = "删除指标规则", description = "删除指标规则，仅 SCHOOL_ADMIN 可操作。")
    @DeleteMapping("/{id}")
    @OperationLog(module = "指标规则", action = "删除指标规则")
    public ApiResponse<Void> delete(@Parameter(description = "指标规则ID", example = "1")
                                    @PathVariable Integer id) {
        systemConfigService.deleteIndicatorRule(id);
        return ApiResponse.success();
    }
}