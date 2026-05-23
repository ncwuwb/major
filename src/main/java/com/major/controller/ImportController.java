package com.major.controller;

import com.major.common.response.ApiResponse;
import com.major.service.ImportService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.io.IOException;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@Tag(name = "数据导入", description = "教师、学生、课程、招生、经费和毕业去向等模板导入与模板下载接口")
@RestController
@RequestMapping("/api/import")
public class ImportController {

    private final ImportService importService;

    public ImportController(ImportService importService) {
        this.importService = importService;
    }

    @Operation(summary = "导入模板数据", description = "支持 teachers、students、courses、admissions、fundings、graduate-outcomes 六类 Excel/CSV 模板导入。主数据重复报错，年度数据按业务唯一键覆盖更新。")
    @PostMapping("/{type}")
    @PreAuthorize("hasAnyAuthority('SCHOOL_ADMIN','DEPT_ADMIN')")
    public ApiResponse<?> importData(
            @Parameter(description = "导入类型：teachers、students、courses、admissions、fundings、graduate-outcomes")
            @PathVariable String type,
            @Parameter(description = "待导入的 Excel 或 CSV 文件")
            @RequestParam("file") MultipartFile file) {
        return ApiResponse.success(importService.importData(type, file));
    }

    @Operation(summary = "下载导入模板", description = "根据导入类型下载对应的空白 Excel 模板文件。")
    @GetMapping("/template/{type}")
    public void downloadTemplate(
            @Parameter(description = "导入类型：teachers、students、courses、admissions、fundings、graduate-outcomes")
            @PathVariable String type,
            @Parameter(hidden = true) HttpServletResponse response) throws IOException {
        importService.downloadTemplate(type, response);
    }
}