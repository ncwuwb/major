package com.major.service;

import com.major.common.exception.BusinessException;
import com.major.domain.entity.DepartmentEntity;
import com.major.domain.entity.MajorEntity;
import com.major.domain.entity.StudentEntity;
import com.major.domain.entity.TeacherEntity;
import com.major.mapper.DepartmentMapper;
import com.major.mapper.MajorMapper;
import com.major.mapper.StudentMapper;
import com.major.mapper.TeacherMapper;
import org.springframework.stereotype.Service;

@Service
public class ReferenceAssertService {

    private final DepartmentMapper departmentMapper;
    private final MajorMapper majorMapper;
    private final TeacherMapper teacherMapper;
    private final StudentMapper studentMapper;

    public ReferenceAssertService(DepartmentMapper departmentMapper, MajorMapper majorMapper,
                                  TeacherMapper teacherMapper, StudentMapper studentMapper) {
        this.departmentMapper = departmentMapper;
        this.majorMapper = majorMapper;
        this.teacherMapper = teacherMapper;
        this.studentMapper = studentMapper;
    }

    public DepartmentEntity requireDepartment(Integer deptId) {
        DepartmentEntity entity = departmentMapper.selectById(deptId);
        if (entity == null || entity.getDeleted() != null && entity.getDeleted() == 1) {
            throw new BusinessException(404, "学院不存在");
        }
        return entity;
    }

    public MajorEntity requireMajor(Integer majorId) {
        MajorEntity entity = majorMapper.selectById(majorId);
        if (entity == null || entity.getDeleted() != null && entity.getDeleted() == 1) {
            throw new BusinessException(404, "专业不存在");
        }
        return entity;
    }

    public TeacherEntity requireTeacher(Integer teacherId) {
        TeacherEntity entity = teacherMapper.selectById(teacherId);
        if (entity == null || entity.getDeleted() != null && entity.getDeleted() == 1) {
            throw new BusinessException(404, "教师不存在");
        }
        return entity;
    }

    public StudentEntity requireStudent(Integer studentId) {
        StudentEntity entity = studentMapper.selectById(studentId);
        if (entity == null || entity.getDeleted() != null && entity.getDeleted() == 1) {
            throw new BusinessException(404, "学生不存在");
        }
        return entity;
    }
}
