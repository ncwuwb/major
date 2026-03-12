package com.major.controller;

import com.major.common.response.ApiResponse;
import com.major.domain.dto.ChangePasswordRequest;
import com.major.domain.dto.LoginRequest;
import com.major.domain.vo.LoginVO;
import com.major.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import javax.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "认证与账户", description = "登录认证、当前用户信息和密码维护接口")
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @Operation(summary = "登录获取 JWT", description = "使用用户名和密码登录，成功后返回 JWT 令牌和当前账号基础信息。")
    @PostMapping("/login")
    public ApiResponse<LoginVO> login(@Valid @RequestBody LoginRequest request) {
        return ApiResponse.success(authService.login(request));
    }

    @Operation(summary = "获取当前登录用户", description = "根据请求头中的 JWT 返回当前登录用户信息、角色和数据权限范围。")
    @GetMapping("/me")
    public ApiResponse<?> me() {
        return ApiResponse.success(authService.currentUser());
    }

    @Operation(summary = "修改当前用户密码", description = "登录后修改当前账号密码。")
    @PostMapping("/change-password")
    public ApiResponse<Void> changePassword(@Valid @RequestBody ChangePasswordRequest request) {
        authService.changePassword(request);
        return ApiResponse.success();
    }
}