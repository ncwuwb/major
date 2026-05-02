package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.major.common.exception.BusinessException;
import com.major.common.model.PageQuery;
import com.major.common.response.PageResponse;
import com.major.common.util.PageUtils;
import com.major.domain.entity.AdmissionEntity;
import com.major.domain.entity.CampusEntity;
import com.major.domain.entity.CourseEntity;
import com.major.domain.entity.DepartmentEntity;
import com.major.domain.entity.ExperimentBaseEntity;
import com.major.domain.entity.FundingEntity;
import com.major.domain.entity.GraduateOutcomeEntity;
import com.major.domain.entity.MajorEntity;
import com.major.domain.entity.SchoolEntity;
import com.major.domain.entity.StudentEntity;
import com.major.domain.entity.SysUserEntity;
import com.major.domain.entity.TeacherEntity;
import com.major.mapper.AdmissionMapper;
import com.major.mapper.CampusMapper;
import com.major.mapper.CourseMapper;
import com.major.mapper.DepartmentMapper;
import com.major.mapper.ExperimentBaseMapper;
import com.major.mapper.FundingMapper;
import com.major.mapper.GraduateOutcomeMapper;
import com.major.mapper.MajorMapper;
import com.major.mapper.SchoolMapper;
import com.major.mapper.StudentMapper;
import com.major.mapper.SysUserMapper;
import com.major.mapper.TeacherMapper;
import java.util.Objects;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class OrganizationService {

    private final SchoolMapper schoolMapper;
    private final CampusMapper campusMapper;
    private final DepartmentMapper departmentMapper;
    private final MajorMapper majorMapper;
    private final TeacherMapper teacherMapper;
    private final StudentMapper studentMapper;
    private final CourseMapper courseMapper;
    private final ExperimentBaseMapper experimentBaseMapper;
    private final AdmissionMapper admissionMapper;
    private final FundingMapper fundingMapper;
    private final GraduateOutcomeMapper graduateOutcomeMapper;
    private final SysUserMapper sysUserMapper;
    private final DataScopeService dataScopeService;
    private final ReferenceAssertService referenceAssertService;
    private final PasswordEncoder passwordEncoder;

    public OrganizationService(SchoolMapper schoolMapper, CampusMapper campusMapper, DepartmentMapper departmentMapper,
                               MajorMapper majorMapper, TeacherMapper teacherMapper, StudentMapper studentMapper,
                               CourseMapper courseMapper, ExperimentBaseMapper experimentBaseMapper,
                               AdmissionMapper admissionMapper, FundingMapper fundingMapper,
                               GraduateOutcomeMapper graduateOutcomeMapper, SysUserMapper sysUserMapper,
                               DataScopeService dataScopeService, ReferenceAssertService referenceAssertService,
                               PasswordEncoder passwordEncoder) {
        this.schoolMapper = schoolMapper;
        this.campusMapper = campusMapper;
        this.departmentMapper = departmentMapper;
        this.majorMapper = majorMapper;
        this.teacherMapper = teacherMapper;
        this.studentMapper = studentMapper;
        this.courseMapper = courseMapper;
        this.experimentBaseMapper = experimentBaseMapper;
        this.admissionMapper = admissionMapper;
        this.fundingMapper = fundingMapper;
        this.graduateOutcomeMapper = graduateOutcomeMapper;
        this.sysUserMapper = sysUserMapper;
        this.dataScopeService = dataScopeService;
        this.referenceAssertService = referenceAssertService;
        this.passwordEncoder = passwordEncoder;
    }

    public PageResponse<SchoolEntity> pageSchools(PageQuery pageQuery, String keyword) {
        QueryWrapper<SchoolEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like("name", keyword).or().like("code", keyword));
        }
        Page<SchoolEntity> page = schoolMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public SchoolEntity getSchool(Integer schoolId) {
        SchoolEntity entity = schoolMapper.selectById(schoolId);
        if (entity == null || (entity.getDeleted() != null && entity.getDeleted() == 1)) {
            throw new BusinessException(404, "School not found");
        }
        return entity;
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void saveSchool(SchoolEntity entity) {
        ensureSchoolCodeUnique(entity.getCode(), null);
        schoolMapper.insert(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void updateSchool(Integer schoolId, SchoolEntity entity) {
        getSchool(schoolId);
        ensureSchoolCodeUnique(entity.getCode(), schoolId);
        entity.setSchoolId(schoolId);
        schoolMapper.updateById(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void deleteSchool(Integer schoolId) {
        getSchool(schoolId);
        if (campusMapper.selectCount(new QueryWrapper<CampusEntity>().eq("school_id", schoolId).eq("deleted", 0)) > 0
                || departmentMapper.selectCount(new QueryWrapper<DepartmentEntity>().eq("school_id", schoolId).eq("deleted", 0)) > 0) {
            throw new BusinessException(400, "School still has campuses or departments");
        }
        schoolMapper.deleteById(schoolId);
    }

    public PageResponse<CampusEntity> pageCampuses(PageQuery pageQuery, String keyword) {
        QueryWrapper<CampusEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        if (StringUtils.hasText(keyword)) {
            wrapper.like("name", keyword);
        }
        Page<CampusEntity> page = campusMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public CampusEntity getCampus(Integer campusId) {
        CampusEntity entity = campusMapper.selectById(campusId);
        if (entity == null || (entity.getDeleted() != null && entity.getDeleted() == 1)) {
            throw new BusinessException(404, "Campus not found");
        }
        return entity;
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void saveCampus(CampusEntity entity) {
        getSchool(entity.getSchoolId());
        campusMapper.insert(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void updateCampus(Integer campusId, CampusEntity entity) {
        getCampus(campusId);
        getSchool(entity.getSchoolId());
        entity.setCampusId(campusId);
        campusMapper.updateById(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void deleteCampus(Integer campusId) {
        getCampus(campusId);
        campusMapper.deleteById(campusId);
    }

    public PageResponse<DepartmentEntity> pageDepartments(PageQuery pageQuery, String keyword) {
        QueryWrapper<DepartmentEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        dataScopeService.applyDeptScope(wrapper, "dept_id");
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like("name", keyword).or().like("code", keyword));
        }
        Page<DepartmentEntity> page = departmentMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public DepartmentEntity getDepartment(Integer deptId) {
        DepartmentEntity entity = referenceAssertService.requireDepartment(deptId);
        dataScopeService.assertCanAccessDept(entity.getDeptId());
        return entity;
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void saveDepartment(DepartmentEntity entity) {
        getSchool(entity.getSchoolId());
        ensureDepartmentCodeUnique(entity.getCode(), null);
        departmentMapper.insert(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void updateDepartment(Integer deptId, DepartmentEntity entity) {
        getDepartment(deptId);
        getSchool(entity.getSchoolId());
        ensureDepartmentCodeUnique(entity.getCode(), deptId);
        entity.setDeptId(deptId);
        departmentMapper.updateById(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void deleteDepartment(Integer deptId) {
        getDepartment(deptId);
        if (majorMapper.selectCount(new QueryWrapper<MajorEntity>().eq("dept_id", deptId).eq("deleted", 0)) > 0
                || teacherMapper.selectCount(new QueryWrapper<TeacherEntity>().eq("dept_id", deptId).eq("deleted", 0)) > 0
                || sysUserMapper.selectCount(new QueryWrapper<SysUserEntity>().eq("scope_type", "DEPT").eq("scope_id", deptId).eq("deleted", 0)) > 0) {
            throw new BusinessException(400, "Department still has related data");
        }
        departmentMapper.deleteById(deptId);
    }

    public PageResponse<MajorEntity> pageMajors(PageQuery pageQuery, String keyword, Integer deptId) {
        QueryWrapper<MajorEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        dataScopeService.applyMajorScope(wrapper, "major_id");
        if (deptId != null) {
            dataScopeService.assertCanAccessDept(deptId);
            wrapper.eq("dept_id", deptId);
        }
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like("name", keyword).or().like("code", keyword));
        }
        Page<MajorEntity> page = majorMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public MajorEntity getMajor(Integer majorId) {
        MajorEntity entity = referenceAssertService.requireMajor(majorId);
        dataScopeService.assertCanAccessMajor(majorId);
        return entity;
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void saveMajor(MajorEntity entity) {
        dataScopeService.assertCanAccessDept(entity.getDeptId());
        referenceAssertService.requireDepartment(entity.getDeptId());
        ensureMajorCodeUnique(entity.getCode(), null);
        majorMapper.insert(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void updateMajor(Integer majorId, MajorEntity entity) {
        getMajor(majorId);
        dataScopeService.assertCanAccessDept(entity.getDeptId());
        referenceAssertService.requireDepartment(entity.getDeptId());
        ensureMajorCodeUnique(entity.getCode(), majorId);
        entity.setMajorId(majorId);
        majorMapper.updateById(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void deleteMajor(Integer majorId) {
        getMajor(majorId);
        boolean hasLinkedData = sysUserMapper.selectCount(new QueryWrapper<SysUserEntity>().eq("scope_type", "MAJOR").eq("scope_id", majorId).eq("deleted", 0)) > 0
                || studentMapper.selectCount(new QueryWrapper<StudentEntity>().eq("major_id", majorId).eq("deleted", 0)) > 0
                || courseMapper.selectCount(new QueryWrapper<CourseEntity>().eq("major_id", majorId).eq("deleted", 0)) > 0
                || experimentBaseMapper.selectCount(new QueryWrapper<ExperimentBaseEntity>().eq("major_id", majorId).eq("deleted", 0)) > 0
                || admissionMapper.selectCount(new QueryWrapper<AdmissionEntity>().eq("major_id", majorId).eq("deleted", 0)) > 0
                || fundingMapper.selectCount(new QueryWrapper<FundingEntity>().eq("major_id", majorId).eq("deleted", 0)) > 0
                || graduateOutcomeMapper.selectCount(new QueryWrapper<GraduateOutcomeEntity>().eq("major_id", majorId).eq("deleted", 0)) > 0;
        if (hasLinkedData) {
            throw new BusinessException(400, "Major still has related data");
        }
        majorMapper.deleteById(majorId);
    }

    public PageResponse<SysUserEntity> pageUsers(PageQuery pageQuery, String keyword) {
        QueryWrapper<SysUserEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like("username", keyword).or().like("real_name", keyword));
        }
        Page<SysUserEntity> page = sysUserMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public SysUserEntity getUser(Long userId) {
        SysUserEntity entity = sysUserMapper.selectById(userId);
        if (entity == null || (entity.getDeleted() != null && entity.getDeleted() == 1)) {
            throw new BusinessException(404, "User not found");
        }
        return entity;
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void saveUser(SysUserEntity entity) {
        ensureUsernameUnique(entity.getUsername(), null);
        validateUserScope(entity.getScopeType(), entity.getScopeId());
        entity.setPassword(passwordEncoder.encode(entity.getPassword()));
        if (entity.getStatus() == null) {
            entity.setStatus(1);
        }
        sysUserMapper.insert(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void updateUser(Long userId, SysUserEntity entity) {
        SysUserEntity existing = getUser(userId);
        ensureUsernameUnique(entity.getUsername(), userId);
        validateUserScope(entity.getScopeType(), entity.getScopeId());
        entity.setUserId(userId);
        if (StringUtils.hasText(entity.getPassword())) {
            entity.setPassword(passwordEncoder.encode(entity.getPassword()));
        } else {
            entity.setPassword(existing.getPassword());
        }
        if (entity.getStatus() == null) {
            entity.setStatus(existing.getStatus());
        }
        sysUserMapper.updateById(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void deleteUser(Long userId) {
        getUser(userId);
        sysUserMapper.deleteById(userId);
    }

    private void validateUserScope(String scopeType, Long scopeId) {
        if (!StringUtils.hasText(scopeType) || scopeId == null) {
            throw new BusinessException(400, "User scope is required");
        }
        if (Objects.equals(scopeType, "SCHOOL")) {
            getSchool(scopeId.intValue());
        } else if (Objects.equals(scopeType, "DEPT")) {
            referenceAssertService.requireDepartment(scopeId.intValue());
        } else if (Objects.equals(scopeType, "MAJOR")) {
            referenceAssertService.requireMajor(scopeId.intValue());
        } else {
            throw new BusinessException(400, "Invalid scope type");
        }
    }

    private void ensureSchoolCodeUnique(String code, Integer excludeId) {
        QueryWrapper<SchoolEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("code", code).eq("deleted", 0);
        if (excludeId != null) {
            wrapper.ne("school_id", excludeId);
        }
        if (schoolMapper.selectCount(wrapper) > 0) {
            throw new BusinessException(400, "School code already exists");
        }
    }

    private void ensureDepartmentCodeUnique(String code, Integer excludeId) {
        QueryWrapper<DepartmentEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("code", code).eq("deleted", 0);
        if (excludeId != null) {
            wrapper.ne("dept_id", excludeId);
        }
        if (departmentMapper.selectCount(wrapper) > 0) {
            throw new BusinessException(400, "Department code already exists");
        }
    }

    private void ensureMajorCodeUnique(String code, Integer excludeId) {
        QueryWrapper<MajorEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("code", code).eq("deleted", 0);
        if (excludeId != null) {
            wrapper.ne("major_id", excludeId);
        }
        if (majorMapper.selectCount(wrapper) > 0) {
            throw new BusinessException(400, "Major code already exists");
        }
    }

    private void ensureUsernameUnique(String username, Long excludeId) {
        QueryWrapper<SysUserEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("username", username).eq("deleted", 0);
        if (excludeId != null) {
            wrapper.ne("user_id", excludeId);
        }
        if (sysUserMapper.selectCount(wrapper) > 0) {
            throw new BusinessException(400, "Username already exists");
        }
    }
}