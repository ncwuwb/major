package com.major.common.model;

import io.swagger.v3.oas.annotations.media.Schema;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import lombok.Data;

@Data
@Schema(description = "分页参数")
public class PageQuery {

    @Min(1)
    @Schema(description = "页码", example = "1", defaultValue = "1")
    private long pageNum = 1;

    @Min(1)
    @Max(200)
    @Schema(description = "每页条数", example = "10", defaultValue = "10")
    private long pageSize = 10;
}