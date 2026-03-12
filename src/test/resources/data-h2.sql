INSERT INTO school (school_id, name, code, type, nature, level, website, contact_name, contact_phone, deleted) VALUES
(1, '示例医科大学', 'SCH001', '本科', '公办', '省属重点', 'https://www.example.edu.cn', '张老师', '13800000001', 0);

INSERT INTO department (dept_id, school_id, code, name, type, deleted) VALUES
(1, 1, 'DEP001', '护理学院', '学院', 0),
(2, 1, 'DEP002', '医学技术学院', '学院', 0);

INSERT INTO major (major_id, dept_id, name, code, level, category, duration_years, deleted) VALUES
(1, 1, '护理学', 'MAJ001', '本科', '医学', 4, 0),
(2, 2, '医学检验技术', 'MAJ002', '本科', '医学技术', 4, 0);

INSERT INTO sys_user (user_id, username, password, real_name, role_code, scope_type, scope_id, status, deleted) VALUES
(1, 'admin', '{noop}admin123456', '系统管理员', 'SCHOOL_ADMIN', 'SCHOOL', 1, 1, 0),
(2, 'deptadmin', '{noop}admin123456', '学院管理员', 'DEPT_ADMIN', 'DEPT', 1, 1, 0),
(3, 'majoradmin', '{noop}admin123456', '专业管理员', 'MAJOR_ADMIN', 'MAJOR', 1, 1, 0);

INSERT INTO teacher (teacher_id, dept_id, teacher_no, name, title, degree, phd_flag, employment_type, deleted) VALUES
(1, 1, 'T001', '王芳', '教授', '博士', 1, '专任', 0),
(2, 1, 'T002', '李敏', '副教授', '硕士', 0, '专任', 0),
(3, 2, 'T003', '陈涛', '教授', '博士', 1, '专任', 0);

INSERT INTO student (student_id, major_id, student_no, name, gender, enrollment_year, status, deleted) VALUES
(1, 1, 'S001', '刘洋', 'M', 2022, '在校', 0),
(2, 1, 'S002', '孙悦', 'F', 2022, '在校', 0),
(3, 2, 'S003', '高翔', 'M', 2021, '毕业', 0);

INSERT INTO admission (admission_id, major_id, stat_year, plan_count, actual_count, min_score, max_score, deleted) VALUES
(1, 1, 2025, 120, 110, 520.00, 588.00, 0),
(2, 2, 2025, 90, 88, 510.00, 578.00, 0);

INSERT INTO funding (funding_id, major_id, stat_year, allocated, spent, utilization_rate, deleted) VALUES
(1, 1, 2025, 200.00, 150.00, 75.00, 0),
(2, 2, 2025, 180.00, 100.00, 55.56, 0);

INSERT INTO graduate_outcome (outcome_id, major_id, stat_year, graduate_count, employment_rate, postgraduate_rate, average_salary, deleted) VALUES
(1, 1, 2025, 110, 92.00, 18.00, 6800.00, 0),
(2, 2, 2025, 80, 78.00, 12.00, 6100.00, 0);

INSERT INTO indicator_rule (rule_id, indicator_code, indicator_name, weight, compare_type, threshold_value, enabled, deleted) VALUES
(1, 'PHD_RATE', '博士占比', 20.00, 'LT', 40.00, 1, 0),
(2, 'ADMISSION_COMPLETION_RATE', '招生完成率', 20.00, 'LT', 90.00, 1, 0),
(3, 'FUNDING_UTILIZATION_RATE', '经费使用率', 20.00, 'LT', 70.00, 1, 0),
(4, 'EMPLOYMENT_RATE', '就业率', 20.00, 'LT', 80.00, 1, 0),
(5, 'POSTGRADUATE_RATE', '升学率', 20.00, 'LT', 15.00, 1, 0);
