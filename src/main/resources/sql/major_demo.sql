SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO `school` (`school_id`, `name`, `code`, `type`, `nature`, `level`, `website`, `contact_name`, `contact_phone`) VALUES
(1, '示例医科大学', 'SCH001', '本科', '公办', '省属重点', 'https://www.example.edu.cn', '张老师', '13800000001');

INSERT INTO `campus` (`campus_id`, `school_id`, `name`, `province`, `city`, `district`, `is_main`) VALUES
(1, 1, '主校区', '江苏省', '南京市', '江宁区', 1),
(2, 1, '临床校区', '江苏省', '南京市', '鼓楼区', 0);

INSERT INTO `department` (`dept_id`, `school_id`, `code`, `name`, `type`) VALUES
(1, 1, 'DEP001', '护理学院', '学院'),
(2, 1, 'DEP002', '医学技术学院', '学院');

INSERT INTO `major` (`major_id`, `dept_id`, `name`, `code`, `level`, `category`, `duration_years`) VALUES
(1, 1, '护理学', 'MAJ001', '本科', '医学', 4),
(2, 1, '助产学', 'MAJ002', '本科', '医学', 4),
(3, 2, '医学检验技术', 'MAJ003', '本科', '医学技术', 4);

INSERT INTO `teacher` (`teacher_id`, `dept_id`, `teacher_no`, `name`, `title`, `degree`, `phd_flag`, `employment_type`) VALUES
(1, 1, 'T001', '王芳', '教授', '博士', 1, '专任'),
(2, 1, 'T002', '李敏', '副教授', '硕士', 0, '专任'),
(3, 1, 'T003', '周洁', '讲师', '博士', 1, '兼职'),
(4, 2, 'T004', '陈涛', '教授', '博士', 1, '专任'),
(5, 2, 'T005', '赵蕾', '副教授', '硕士', 0, '校外导师');

INSERT INTO `student` (`student_id`, `major_id`, `student_no`, `name`, `gender`, `enrollment_year`, `status`) VALUES
(1, 1, 'S001', '刘洋', 'M', 2022, '在校'),
(2, 1, 'S002', '孙悦', 'F', 2022, '在校'),
(3, 2, 'S003', '杨静', 'F', 2021, '在校'),
(4, 2, 'S004', '吴彤', 'F', 2021, '毕业'),
(5, 3, 'S005', '高翔', 'M', 2022, '在校'),
(6, 3, 'S006', '程琳', 'F', 2021, '毕业');

INSERT INTO `course` (`course_id`, `major_id`, `course_code`, `name`, `type`, `credits`, `semester`) VALUES
(1, 1, 'C001', '基础护理学', '必修', 4.0, '第3学期'),
(2, 1, 'C002', '内科护理学', '必修', 3.5, '第5学期'),
(3, 2, 'C003', '助产技术', '必修', 3.0, '第4学期'),
(4, 2, 'C004', '围产保健', '选修', 2.0, '第5学期'),
(5, 3, 'C005', '临床检验基础', '必修', 4.0, '第3学期'),
(6, 3, 'C006', '微生物检验', '必修', 3.0, '第5学期');

INSERT INTO `experiment_base` (`base_id`, `major_id`, `name`, `type`, `location`, `capacity`) VALUES
(1, 1, '护理实训中心', '校内', '主校区实验楼', 120),
(2, 2, '妇产科实践基地', '附属医院', '附属医院住院部', 60),
(3, 3, '医学检验实训室', '校内', '临床校区检验楼', 90);

INSERT INTO `admission` (`admission_id`, `major_id`, `stat_year`, `plan_count`, `actual_count`, `min_score`, `max_score`) VALUES
(1, 1, 2024, 120, 114, 520.00, 589.00),
(2, 2, 2024, 80, 70, 505.00, 560.00),
(3, 3, 2024, 90, 88, 510.00, 578.00),
(4, 1, 2025, 130, 128, 525.00, 592.00),
(5, 2, 2025, 90, 76, 506.00, 565.00),
(6, 3, 2025, 95, 92, 514.00, 581.00);

INSERT INTO `funding` (`funding_id`, `major_id`, `stat_year`, `allocated`, `spent`, `utilization_rate`) VALUES
(1, 1, 2024, 220.00, 180.00, 81.82),
(2, 2, 2024, 160.00, 98.00, 61.25),
(3, 3, 2024, 190.00, 154.00, 81.05),
(4, 1, 2025, 250.00, 205.00, 82.00),
(5, 2, 2025, 180.00, 115.00, 63.89),
(6, 3, 2025, 210.00, 175.00, 83.33);

INSERT INTO `graduate_outcome` (`outcome_id`, `major_id`, `stat_year`, `graduate_count`, `employment_rate`, `postgraduate_rate`, `average_salary`) VALUES
(1, 1, 2024, 110, 92.50, 18.00, 6800.00),
(2, 2, 2024, 72, 78.00, 12.00, 6100.00),
(3, 3, 2024, 85, 88.00, 22.00, 7200.00),
(4, 1, 2025, 118, 93.00, 19.00, 7100.00),
(5, 2, 2025, 75, 79.50, 13.00, 6300.00),
(6, 3, 2025, 90, 89.00, 24.00, 7500.00);

INSERT INTO `achievement` (`achievement_id`, `teacher_id`, `name`, `type`, `stat_year`, `unit_count`) VALUES
(1, 1, '基于临床护理能力培养的课程改革', '教学项目', 2024, 2),
(2, 1, '护理技能竞赛指导成果', '获奖', 2025, 1),
(3, 4, '智慧检验实验课程建设', '论文', 2024, 3),
(4, 4, '医学检验人才培养模式研究', '科研项目', 2025, 2);

INSERT INTO `competition` (`competition_id`, `student_id`, `name`, `level`, `award`, `stat_year`) VALUES
(1, 1, '全国护理技能大赛', '国家级', '二等奖', 2024),
(2, 3, '省级助产技能竞赛', '省级', '一等奖', 2024),
(3, 5, '医学检验技能竞赛', '国家级', '三等奖', 2025),
(4, 6, '大学生创新创业竞赛', '省级', '二等奖', 2025);

INSERT INTO `international_exchange` (`exchange_id`, `student_id`, `program`, `stat_year`, `outcome`) VALUES
(1, 2, '护理国际交流项目', 2024, '完成海外临床见习'),
(2, 5, '检验技术交流访问', 2025, '发表交流报告');

INSERT INTO `indicator_rule` (`rule_id`, `indicator_code`, `indicator_name`, `weight`, `compare_type`, `threshold_value`, `enabled`, `remark`) VALUES
(1, 'PHD_RATE', '博士占比', 20.00, 'LT', 40.00, 1, '低于40%触发预警'),
(2, 'ADMISSION_COMPLETION_RATE', '招生完成率', 20.00, 'LT', 90.00, 1, '低于90%触发预警'),
(3, 'FUNDING_UTILIZATION_RATE', '经费使用率', 20.00, 'LT', 70.00, 1, '低于70%触发预警'),
(4, 'EMPLOYMENT_RATE', '就业率', 20.00, 'LT', 80.00, 1, '低于80%触发预警'),
(5, 'POSTGRADUATE_RATE', '升学率', 20.00, 'LT', 15.00, 1, '低于15%触发预警');

INSERT INTO `report_template` (`template_id`, `name`, `description`, `format`) VALUES
(1, '专业年度总览', '用于导出专业年度指标汇总', 'EXCEL'),
(2, '预警清单', '用于导出当前预警记录', 'EXCEL');

SET FOREIGN_KEY_CHECKS = 1;
