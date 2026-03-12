package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.major.common.exception.BusinessException;
import com.major.domain.dto.ChangePasswordRequest;
import com.major.domain.dto.LoginRequest;
import com.major.domain.entity.SysUserEntity;
import com.major.domain.vo.LoginVO;
import com.major.mapper.SysUserMapper;
import com.major.security.JwtTokenProvider;
import com.major.security.LoginUser;
import com.major.security.SecurityUtils;
import java.time.LocalDateTime;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final SysUserMapper sysUserMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    public AuthService(SysUserMapper sysUserMapper, PasswordEncoder passwordEncoder,
                       JwtTokenProvider jwtTokenProvider) {
        this.sysUserMapper = sysUserMapper;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    public LoginVO login(LoginRequest request) {
        LambdaQueryWrapper<SysUserEntity> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(SysUserEntity::getUsername, request.getUsername())
                .eq(SysUserEntity::getDeleted, 0)
                .last("limit 1");
        SysUserEntity user = sysUserMapper.selectOne(queryWrapper);
        if (user == null || user.getStatus() == null || user.getStatus() != 1) {
            throw new BusinessException(401, "用户名或密码错误");
        }
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new BusinessException(401, "用户名或密码错误");
        }
        user.setLastLoginAt(LocalDateTime.now());
        sysUserMapper.updateById(user);
        LoginUser loginUser = LoginUser.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .password(user.getPassword())
                .realName(user.getRealName())
                .roleCode(user.getRoleCode())
                .scopeType(user.getScopeType())
                .scopeId(user.getScopeId())
                .enabled(true)
                .build();
        LoginVO loginVO = new LoginVO();
        loginVO.setToken(jwtTokenProvider.generateToken(loginUser));
        loginVO.setUserId(user.getUserId());
        loginVO.setUsername(user.getUsername());
        loginVO.setRealName(user.getRealName());
        loginVO.setRoleCode(user.getRoleCode());
        loginVO.setScopeType(user.getScopeType());
        loginVO.setScopeId(user.getScopeId());
        return loginVO;
    }

    public SysUserEntity currentUser() {
        return sysUserMapper.selectById(SecurityUtils.getUserId());
    }

    public void changePassword(ChangePasswordRequest request) {
        SysUserEntity user = sysUserMapper.selectById(SecurityUtils.getUserId());
        if (user == null) {
            throw new BusinessException(404, "当前用户不存在");
        }
        if (!passwordEncoder.matches(request.getOldPassword(), user.getPassword())) {
            throw new BusinessException(400, "旧密码不正确");
        }
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        sysUserMapper.updateById(user);
    }
}
