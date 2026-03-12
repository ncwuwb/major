package com.major.security;

import com.major.common.exception.BusinessException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public final class SecurityUtils {

    private SecurityUtils() {
    }

    public static LoginUser getLoginUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !(authentication.getPrincipal() instanceof LoginUser)) {
            throw new BusinessException(401, "未登录或登录状态已失效");
        }
        return (LoginUser) authentication.getPrincipal();
    }

    public static Long getUserId() {
        return getLoginUser().getUserId();
    }
}
