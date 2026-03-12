package com.major.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import javax.validation.constraints.NotBlank;
import lombok.Data;

@Data
@Schema(description = "修改密码请求")
public class ChangePasswordRequest {

    @NotBlank
    @Schema(description = "旧密码", example = "admin123456")
    private String oldPassword;

    @NotBlank
    @Schema(description = "新密码", example = "newPassword123")
    private String newPassword;
}