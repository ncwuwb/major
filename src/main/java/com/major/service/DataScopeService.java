package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.major.common.constant.RoleConstants;
import com.major.common.constant.ScopeConstants;
import com.major.common.exception.BusinessException;
import com.major.domain.entity.MajorEntity;
import com.major.mapper.MajorMapper;
import com.major.security.LoginUser;
import com.major.security.SecurityUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class DataScopeService {

    private final MajorMapper majorMapper;

    public DataScopeService(MajorMapper majorMapper) {
        this.majorMapper = majorMapper;
    }

    public void applyDeptScope(QueryWrapper<?> wrapper, String deptField) {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (RoleConstants.SCHOOL_ADMIN.equals(loginUser.getRoleCode())) {
            return;
        }
        Integer deptId = resolveCurrentDeptId();
        wrapper.eq(deptField, deptId);
    }

    public void applyMajorScope(QueryWrapper<?> wrapper, String majorField) {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (RoleConstants.SCHOOL_ADMIN.equals(loginUser.getRoleCode())) {
            return;
        }
        if (RoleConstants.DEPT_ADMIN.equals(loginUser.getRoleCode())) {
            wrapper.inSql(majorField, "select major_id from major where dept_id = " + loginUser.getScopeId() + " and deleted = 0");
            return;
        }
        wrapper.eq(majorField, loginUser.getScopeId());
    }

    public void applyStudentScope(QueryWrapper<?> wrapper, String studentField) {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (RoleConstants.SCHOOL_ADMIN.equals(loginUser.getRoleCode())) {
            return;
        }
        if (RoleConstants.DEPT_ADMIN.equals(loginUser.getRoleCode())) {
            wrapper.inSql(studentField,
                    "select student_id from student where major_id in (select major_id from major where dept_id = "
                            + loginUser.getScopeId() + " and deleted = 0) and deleted = 0");
            return;
        }
        wrapper.inSql(studentField,
                "select student_id from student where major_id = " + loginUser.getScopeId() + " and deleted = 0");
    }

    public void assertCanAccessDept(Integer deptId) {
        if (deptId == null) {
            return;
        }
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (RoleConstants.SCHOOL_ADMIN.equals(loginUser.getRoleCode())) {
            return;
        }
        Integer currentDeptId = resolveCurrentDeptId();
        if (!deptId.equals(currentDeptId)) {
            throw new BusinessException(403, "当前用户无权访问该学院数据");
        }
    }

    public void assertCanAccessMajor(Integer majorId) {
        if (majorId == null) {
            return;
        }
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (RoleConstants.SCHOOL_ADMIN.equals(loginUser.getRoleCode())) {
            return;
        }
        if (RoleConstants.MAJOR_ADMIN.equals(loginUser.getRoleCode()) && !majorId.equals(loginUser.getScopeId().intValue())) {
            throw new BusinessException(403, "当前用户无权访问该专业数据");
        }
        if (RoleConstants.DEPT_ADMIN.equals(loginUser.getRoleCode())) {
            MajorEntity major = majorMapper.selectById(majorId);
            if (major == null || !major.getDeptId().equals(loginUser.getScopeId().intValue())) {
                throw new BusinessException(403, "当前用户无权访问该专业数据");
            }
        }
    }

    public Integer resolveCurrentDeptId() {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (RoleConstants.DEPT_ADMIN.equals(loginUser.getRoleCode())) {
            return loginUser.getScopeId().intValue();
        }
        if (RoleConstants.MAJOR_ADMIN.equals(loginUser.getRoleCode())) {
            MajorEntity major = majorMapper.selectById(loginUser.getScopeId());
            if (major == null) {
                throw new BusinessException(404, "当前专业不存在");
            }
            return major.getDeptId();
        }
        return null;
    }

    public Integer resolveRequestedDeptId(Integer deptId, Integer majorId) {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (RoleConstants.SCHOOL_ADMIN.equals(loginUser.getRoleCode())) {
            if (majorId != null) {
                MajorEntity major = majorMapper.selectById(majorId);
                return major == null ? deptId : major.getDeptId();
            }
            return deptId;
        }
        if (RoleConstants.DEPT_ADMIN.equals(loginUser.getRoleCode())) {
            return loginUser.getScopeId().intValue();
        }
        return resolveCurrentDeptId();
    }

    public Integer resolveRequestedMajorId(Integer majorId) {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (RoleConstants.SCHOOL_ADMIN.equals(loginUser.getRoleCode())) {
            return majorId;
        }
        if (RoleConstants.DEPT_ADMIN.equals(loginUser.getRoleCode())) {
            if (majorId != null) {
                assertCanAccessMajor(majorId);
            }
            return majorId;
        }
        return loginUser.getScopeId().intValue();
    }
}
