package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.major.common.exception.BusinessException;
import com.major.common.model.PageQuery;
import com.major.common.response.PageResponse;
import com.major.common.util.PageUtils;
import com.major.domain.entity.AchievementEntity;
import com.major.domain.entity.CompetitionEntity;
import com.major.domain.entity.CourseEntity;
import com.major.domain.entity.ExperimentBaseEntity;
import com.major.domain.entity.InternationalExchangeEntity;
import com.major.domain.entity.StudentEntity;
import com.major.domain.entity.TeacherEntity;
import com.major.mapper.AchievementMapper;
import com.major.mapper.CompetitionMapper;
import com.major.mapper.CourseMapper;
import com.major.mapper.ExperimentBaseMapper;
import com.major.mapper.InternationalExchangeMapper;
import com.major.mapper.StudentMapper;
import com.major.mapper.TeacherMapper;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class MasterDataService {

    private final TeacherMapper teacherMapper;
    private final StudentMapper studentMapper;
    private final CourseMapper courseMapper;
    private final ExperimentBaseMapper experimentBaseMapper;
    private final CompetitionMapper competitionMapper;
    private final InternationalExchangeMapper internationalExchangeMapper;
    private final AchievementMapper achievementMapper;
    private final DataScopeService dataScopeService;
    private final ReferenceAssertService referenceAssertService;
    private final WarningService warningService;

    public MasterDataService(TeacherMapper teacherMapper, StudentMapper studentMapper, CourseMapper courseMapper,
                             ExperimentBaseMapper experimentBaseMapper, CompetitionMapper competitionMapper,
                             InternationalExchangeMapper internationalExchangeMapper, AchievementMapper achievementMapper,
                             DataScopeService dataScopeService, ReferenceAssertService referenceAssertService,
                             @Lazy WarningService warningService) {
        this.teacherMapper = teacherMapper;
        this.studentMapper = studentMapper;
        this.courseMapper = courseMapper;
        this.experimentBaseMapper = experimentBaseMapper;
        this.competitionMapper = competitionMapper;
        this.internationalExchangeMapper = internationalExchangeMapper;
        this.achievementMapper = achievementMapper;
        this.dataScopeService = dataScopeService;
        this.referenceAssertService = referenceAssertService;
        this.warningService = warningService;
    }

    public PageResponse<TeacherEntity> pageTeachers(PageQuery pageQuery, String keyword, Integer deptId) {
        QueryWrapper<TeacherEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        dataScopeService.applyDeptScope(wrapper, "dept_id");
        if (deptId != null) {
            dataScopeService.assertCanAccessDept(deptId);
            wrapper.eq("dept_id", deptId);
        }
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like("name", keyword).or().like("teacher_no", keyword));
        }
        Page<TeacherEntity> page = teacherMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public TeacherEntity getTeacher(Integer teacherId) {
        TeacherEntity entity = referenceAssertService.requireTeacher(teacherId);
        dataScopeService.assertCanAccessDept(entity.getDeptId());
        return entity;
    }

    public void saveTeacher(TeacherEntity entity) {
        dataScopeService.assertCanAccessDept(entity.getDeptId());
        referenceAssertService.requireDepartment(entity.getDeptId());
        ensureTeacherNoUnique(entity.getTeacherNo(), null);
        teacherMapper.insert(entity);
        warningService.recalculateByDept(entity.getDeptId());
    }

    public void updateTeacher(Integer teacherId, TeacherEntity entity) {
        TeacherEntity existing = getTeacher(teacherId);
        dataScopeService.assertCanAccessDept(entity.getDeptId());
        referenceAssertService.requireDepartment(entity.getDeptId());
        ensureTeacherNoUnique(entity.getTeacherNo(), teacherId);
        entity.setTeacherId(teacherId);
        teacherMapper.updateById(entity);
        warningService.recalculateByDept(existing.getDeptId());
        if (!existing.getDeptId().equals(entity.getDeptId())) {
            warningService.recalculateByDept(entity.getDeptId());
        }
    }

    public void deleteTeacher(Integer teacherId) {
        TeacherEntity teacher = getTeacher(teacherId);
        if (achievementMapper.selectCount(new QueryWrapper<AchievementEntity>().eq("teacher_id", teacherId).eq("deleted", 0)) > 0) {
            throw new BusinessException(400, "Teacher still has achievements");
        }
        teacherMapper.deleteById(teacherId);
        warningService.recalculateByDept(teacher.getDeptId());
    }

    public PageResponse<StudentEntity> pageStudents(PageQuery pageQuery, String keyword, Integer majorId) {
        QueryWrapper<StudentEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        dataScopeService.applyMajorScope(wrapper, "major_id");
        if (majorId != null) {
            dataScopeService.assertCanAccessMajor(majorId);
            wrapper.eq("major_id", majorId);
        }
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like("name", keyword).or().like("student_no", keyword));
        }
        Page<StudentEntity> page = studentMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public StudentEntity getStudent(Integer studentId) {
        StudentEntity entity = referenceAssertService.requireStudent(studentId);
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        return entity;
    }

    public void saveStudent(StudentEntity entity) {
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        referenceAssertService.requireMajor(entity.getMajorId());
        ensureStudentNoUnique(entity.getStudentNo(), null);
        studentMapper.insert(entity);
    }

    public void updateStudent(Integer studentId, StudentEntity entity) {
        getStudent(studentId);
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        referenceAssertService.requireMajor(entity.getMajorId());
        ensureStudentNoUnique(entity.getStudentNo(), studentId);
        entity.setStudentId(studentId);
        studentMapper.updateById(entity);
    }

    public void deleteStudent(Integer studentId) {
        if (competitionMapper.selectCount(new QueryWrapper<CompetitionEntity>().eq("student_id", studentId).eq("deleted", 0)) > 0
                || internationalExchangeMapper.selectCount(new QueryWrapper<InternationalExchangeEntity>().eq("student_id", studentId).eq("deleted", 0)) > 0) {
            throw new BusinessException(400, "Student still has competition or exchange records");
        }
        getStudent(studentId);
        studentMapper.deleteById(studentId);
    }

    public PageResponse<CourseEntity> pageCourses(PageQuery pageQuery, String keyword, Integer majorId) {
        QueryWrapper<CourseEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        dataScopeService.applyMajorScope(wrapper, "major_id");
        if (majorId != null) {
            dataScopeService.assertCanAccessMajor(majorId);
            wrapper.eq("major_id", majorId);
        }
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like("name", keyword).or().like("course_code", keyword));
        }
        Page<CourseEntity> page = courseMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public CourseEntity getCourse(Integer courseId) {
        CourseEntity entity = courseMapper.selectById(courseId);
        if (entity == null || (entity.getDeleted() != null && entity.getDeleted() == 1)) {
            throw new BusinessException(404, "Course not found");
        }
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        return entity;
    }

    public void saveCourse(CourseEntity entity) {
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        referenceAssertService.requireMajor(entity.getMajorId());
        ensureCourseCodeUnique(entity.getCourseCode(), null);
        courseMapper.insert(entity);
    }

    public void updateCourse(Integer courseId, CourseEntity entity) {
        getCourse(courseId);
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        referenceAssertService.requireMajor(entity.getMajorId());
        ensureCourseCodeUnique(entity.getCourseCode(), courseId);
        entity.setCourseId(courseId);
        courseMapper.updateById(entity);
    }

    public void deleteCourse(Integer courseId) {
        getCourse(courseId);
        courseMapper.deleteById(courseId);
    }

    public PageResponse<ExperimentBaseEntity> pageExperimentBases(PageQuery pageQuery, String keyword, Integer majorId) {
        QueryWrapper<ExperimentBaseEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        dataScopeService.applyMajorScope(wrapper, "major_id");
        if (majorId != null) {
            dataScopeService.assertCanAccessMajor(majorId);
            wrapper.eq("major_id", majorId);
        }
        if (StringUtils.hasText(keyword)) {
            wrapper.like("name", keyword);
        }
        Page<ExperimentBaseEntity> page = experimentBaseMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public ExperimentBaseEntity getExperimentBase(Integer baseId) {
        ExperimentBaseEntity entity = experimentBaseMapper.selectById(baseId);
        if (entity == null || (entity.getDeleted() != null && entity.getDeleted() == 1)) {
            throw new BusinessException(404, "Experiment base not found");
        }
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        return entity;
    }

    public void saveExperimentBase(ExperimentBaseEntity entity) {
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        referenceAssertService.requireMajor(entity.getMajorId());
        experimentBaseMapper.insert(entity);
    }

    public void updateExperimentBase(Integer baseId, ExperimentBaseEntity entity) {
        getExperimentBase(baseId);
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        referenceAssertService.requireMajor(entity.getMajorId());
        entity.setBaseId(baseId);
        experimentBaseMapper.updateById(entity);
    }

    public void deleteExperimentBase(Integer baseId) {
        getExperimentBase(baseId);
        experimentBaseMapper.deleteById(baseId);
    }

    private void ensureTeacherNoUnique(String teacherNo, Integer excludeId) {
        QueryWrapper<TeacherEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("teacher_no", teacherNo).eq("deleted", 0);
        if (excludeId != null) {
            wrapper.ne("teacher_id", excludeId);
        }
        if (teacherMapper.selectCount(wrapper) > 0) {
            throw new BusinessException(400, "Teacher number already exists");
        }
    }

    private void ensureStudentNoUnique(String studentNo, Integer excludeId) {
        QueryWrapper<StudentEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("student_no", studentNo).eq("deleted", 0);
        if (excludeId != null) {
            wrapper.ne("student_id", excludeId);
        }
        if (studentMapper.selectCount(wrapper) > 0) {
            throw new BusinessException(400, "Student number already exists");
        }
    }

    private void ensureCourseCodeUnique(String courseCode, Integer excludeId) {
        QueryWrapper<CourseEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("course_code", courseCode).eq("deleted", 0);
        if (excludeId != null) {
            wrapper.ne("course_id", excludeId);
        }
        if (courseMapper.selectCount(wrapper) > 0) {
            throw new BusinessException(400, "Course code already exists");
        }
    }
}