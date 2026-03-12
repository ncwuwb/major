package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.major.domain.entity.SysUserEntity;
import com.major.mapper.SysUserMapper;
import com.major.security.LoginUser;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    private final SysUserMapper sysUserMapper;

    public UserDetailsServiceImpl(SysUserMapper sysUserMapper) {
        this.sysUserMapper = sysUserMapper;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        LambdaQueryWrapper<SysUserEntity> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(SysUserEntity::getUsername, username)
                .eq(SysUserEntity::getDeleted, 0)
                .last("limit 1");
        SysUserEntity user = sysUserMapper.selectOne(queryWrapper);
        if (user == null || user.getStatus() == null || user.getStatus() != 1) {
            throw new UsernameNotFoundException("用户不存在或已禁用");
        }
        return LoginUser.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .password(user.getPassword())
                .realName(user.getRealName())
                .roleCode(user.getRoleCode())
                .scopeType(user.getScopeType())
                .scopeId(user.getScopeId())
                .enabled(true)
                .build();
    }
}
