SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `warning_record`;
DROP TABLE IF EXISTS `operation_log`;
DROP TABLE IF EXISTS `import_task`;
DROP TABLE IF EXISTS `report_template`;
DROP TABLE IF EXISTS `indicator_rule`;
DROP TABLE IF EXISTS `achievement`;
DROP TABLE IF EXISTS `graduate_outcome`;
DROP TABLE IF EXISTS `international_exchange`;
DROP TABLE IF EXISTS `competition`;
DROP TABLE IF EXISTS `funding`;
DROP TABLE IF EXISTS `admission`;
DROP TABLE IF EXISTS `experiment_base`;
DROP TABLE IF EXISTS `course`;
DROP TABLE IF EXISTS `student`;
DROP TABLE IF EXISTS `teacher`;
DROP TABLE IF EXISTS `sys_user`;
DROP TABLE IF EXISTS `major`;
DROP TABLE IF EXISTS `department`;
DROP TABLE IF EXISTS `campus`;
DROP TABLE IF EXISTS `school`;

CREATE TABLE `school` (
  `school_id` INT NOT NULL AUTO_INCREMENT COMMENT '学校ID',
  `name` VARCHAR(255) NOT NULL COMMENT '学校名称',
  `code` VARCHAR(50) NOT NULL COMMENT '学校代码',
  `type` VARCHAR(50) DEFAULT NULL COMMENT '办学类型',
  `nature` VARCHAR(50) DEFAULT NULL COMMENT '学校性质',
  `level` VARCHAR(50) DEFAULT NULL COMMENT '学校层次或等级',
  `website` VARCHAR(255) DEFAULT NULL COMMENT '学校网址',
  `contact_name` VARCHAR(100) DEFAULT NULL COMMENT '联系人姓名',
  `contact_phone` VARCHAR(20) DEFAULT NULL COMMENT '联系人电话',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`school_id`),
  UNIQUE KEY `uk_school_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学校信息表';

CREATE TABLE `campus` (
  `campus_id` INT NOT NULL AUTO_INCREMENT COMMENT '校区ID',
  `school_id` INT NOT NULL COMMENT '所属学校ID',
  `name` VARCHAR(255) NOT NULL COMMENT '校区名称',
  `province` VARCHAR(50) DEFAULT NULL COMMENT '省份',
  `city` VARCHAR(50) DEFAULT NULL COMMENT '城市',
  `district` VARCHAR(50) DEFAULT NULL COMMENT '区县',
  `is_main` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否主校区',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`campus_id`),
  KEY `idx_campus_school_id` (`school_id`),
  CONSTRAINT `fk_campus_school` FOREIGN KEY (`school_id`) REFERENCES `school` (`school_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='校区信息表';

CREATE TABLE `department` (
  `dept_id` INT NOT NULL AUTO_INCREMENT COMMENT '学院ID',
  `school_id` INT NOT NULL COMMENT '所属学校ID',
  `code` VARCHAR(50) NOT NULL COMMENT '学院编码',
  `name` VARCHAR(255) NOT NULL COMMENT '学院名称',
  `type` VARCHAR(50) DEFAULT NULL COMMENT '单位类型',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`dept_id`),
  UNIQUE KEY `uk_department_code` (`code`),
  KEY `idx_department_school_id` (`school_id`),
  CONSTRAINT `fk_department_school` FOREIGN KEY (`school_id`) REFERENCES `school` (`school_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学院信息表';

CREATE TABLE `major` (
  `major_id` INT NOT NULL AUTO_INCREMENT COMMENT '专业ID',
  `dept_id` INT NOT NULL COMMENT '所属学院ID',
  `name` VARCHAR(255) NOT NULL COMMENT '专业名称',
  `code` VARCHAR(50) NOT NULL COMMENT '专业代码',
  `level` VARCHAR(50) DEFAULT NULL COMMENT '培养层次',
  `category` VARCHAR(50) DEFAULT NULL COMMENT '专业类别',
  `duration_years` INT DEFAULT NULL COMMENT '学制年限',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`major_id`),
  UNIQUE KEY `uk_major_code` (`code`),
  KEY `idx_major_dept_id` (`dept_id`),
  CONSTRAINT `fk_major_department` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='专业信息表';

CREATE TABLE `sys_user` (
  `user_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(64) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码',
  `real_name` VARCHAR(100) NOT NULL COMMENT '真实姓名',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `role_code` VARCHAR(32) NOT NULL COMMENT '角色编码',
  `scope_type` VARCHAR(32) NOT NULL COMMENT '权限范围类型',
  `scope_id` BIGINT NOT NULL COMMENT '权限范围ID',
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态',
  `last_login_at` DATETIME DEFAULT NULL COMMENT '最后登录时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_sys_user_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

CREATE TABLE `teacher` (
  `teacher_id` INT NOT NULL AUTO_INCREMENT COMMENT '教师ID',
  `dept_id` INT NOT NULL COMMENT '所属学院ID',
  `teacher_no` VARCHAR(50) NOT NULL COMMENT '教师工号',
  `name` VARCHAR(100) NOT NULL COMMENT '教师姓名',
  `title` VARCHAR(50) DEFAULT NULL COMMENT '职称',
  `degree` VARCHAR(50) DEFAULT NULL COMMENT '学位',
  `phd_flag` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否博士',
  `employment_type` VARCHAR(50) DEFAULT NULL COMMENT '聘用类型',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`teacher_id`),
  UNIQUE KEY `uk_teacher_no` (`teacher_no`),
  KEY `idx_teacher_dept_id` (`dept_id`),
  CONSTRAINT `fk_teacher_department` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教师信息表';

CREATE TABLE `student` (
  `student_id` INT NOT NULL AUTO_INCREMENT COMMENT '学生ID',
  `major_id` INT NOT NULL COMMENT '所属专业ID',
  `student_no` VARCHAR(50) NOT NULL COMMENT '学号',
  `name` VARCHAR(100) NOT NULL COMMENT '学生姓名',
  `gender` CHAR(1) DEFAULT NULL COMMENT '性别',
  `enrollment_year` INT DEFAULT NULL COMMENT '入学年份',
  `status` VARCHAR(50) DEFAULT NULL COMMENT '在校状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `uk_student_no` (`student_no`),
  KEY `idx_student_major_id` (`major_id`),
  CONSTRAINT `fk_student_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生信息表';

CREATE TABLE `course` (
  `course_id` INT NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `major_id` INT NOT NULL COMMENT '所属专业ID',
  `course_code` VARCHAR(50) NOT NULL COMMENT '课程代码',
  `name` VARCHAR(255) NOT NULL COMMENT '课程名称',
  `type` VARCHAR(50) DEFAULT NULL COMMENT '课程类型',
  `credits` DECIMAL(4,1) DEFAULT NULL COMMENT '学分',
  `semester` VARCHAR(20) DEFAULT NULL COMMENT '开课学期',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`course_id`),
  UNIQUE KEY `uk_course_code` (`course_code`),
  KEY `idx_course_major_id` (`major_id`),
  CONSTRAINT `fk_course_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程信息表';

CREATE TABLE `experiment_base` (
  `base_id` INT NOT NULL AUTO_INCREMENT COMMENT '实验基地ID',
  `major_id` INT NOT NULL COMMENT '所属专业ID',
  `name` VARCHAR(255) NOT NULL COMMENT '基地名称',
  `type` VARCHAR(50) DEFAULT NULL COMMENT '基地类型',
  `location` VARCHAR(255) DEFAULT NULL COMMENT '基地地址',
  `capacity` INT DEFAULT NULL COMMENT '容纳人数',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`base_id`),
  KEY `idx_experiment_base_major_id` (`major_id`),
  CONSTRAINT `fk_experiment_base_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验基地表';

CREATE TABLE `admission` (
  `admission_id` INT NOT NULL AUTO_INCREMENT COMMENT '招生ID',
  `major_id` INT NOT NULL COMMENT '所属专业ID',
  `stat_year` INT NOT NULL COMMENT '统计年份',
  `plan_count` INT DEFAULT NULL COMMENT '计划人数',
  `actual_count` INT DEFAULT NULL COMMENT '录取人数',
  `min_score` DECIMAL(5,2) DEFAULT NULL COMMENT '最低分',
  `max_score` DECIMAL(5,2) DEFAULT NULL COMMENT '最高分',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`admission_id`),
  UNIQUE KEY `uk_admission_major_year` (`major_id`, `stat_year`),
  CONSTRAINT `fk_admission_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='招生录取表';

CREATE TABLE `funding` (
  `funding_id` INT NOT NULL AUTO_INCREMENT COMMENT '经费ID',
  `major_id` INT NOT NULL COMMENT '所属专业ID',
  `stat_year` INT NOT NULL COMMENT '统计年份',
  `allocated` DECIMAL(12,2) DEFAULT NULL COMMENT '分配经费',
  `spent` DECIMAL(12,2) DEFAULT NULL COMMENT '已使用经费',
  `utilization_rate` DECIMAL(5,2) DEFAULT NULL COMMENT '使用率',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`funding_id`),
  UNIQUE KEY `uk_funding_major_year` (`major_id`, `stat_year`),
  CONSTRAINT `fk_funding_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='专业经费表';

CREATE TABLE `competition` (
  `competition_id` INT NOT NULL AUTO_INCREMENT COMMENT '竞赛ID',
  `student_id` INT NOT NULL COMMENT '学生ID',
  `name` VARCHAR(255) NOT NULL COMMENT '竞赛名称',
  `level` VARCHAR(50) DEFAULT NULL COMMENT '竞赛级别',
  `award` VARCHAR(255) DEFAULT NULL COMMENT '获奖情况',
  `stat_year` INT DEFAULT NULL COMMENT '统计年份',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`competition_id`),
  KEY `idx_competition_student_id` (`student_id`),
  CONSTRAINT `fk_competition_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='竞赛获奖表';

CREATE TABLE `international_exchange` (
  `exchange_id` INT NOT NULL AUTO_INCREMENT COMMENT '国际交流ID',
  `student_id` INT NOT NULL COMMENT '学生ID',
  `program` VARCHAR(255) NOT NULL COMMENT '交流项目',
  `stat_year` INT DEFAULT NULL COMMENT '统计年份',
  `outcome` VARCHAR(255) DEFAULT NULL COMMENT '交流成果',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`exchange_id`),
  KEY `idx_international_exchange_student_id` (`student_id`),
  CONSTRAINT `fk_exchange_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='国际交流表';

CREATE TABLE `graduate_outcome` (
  `outcome_id` INT NOT NULL AUTO_INCREMENT COMMENT '毕业去向ID',
  `major_id` INT NOT NULL COMMENT '所属专业ID',
  `stat_year` INT NOT NULL COMMENT '统计年份',
  `graduate_count` INT NOT NULL DEFAULT 0 COMMENT '毕业人数',
  `employment_rate` DECIMAL(5,2) DEFAULT NULL COMMENT '就业率',
  `postgraduate_rate` DECIMAL(5,2) DEFAULT NULL COMMENT '升学率',
  `average_salary` DECIMAL(10,2) DEFAULT NULL COMMENT '平均薪资',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`outcome_id`),
  UNIQUE KEY `uk_graduate_outcome_major_year` (`major_id`, `stat_year`),
  CONSTRAINT `fk_graduate_outcome_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='毕业去向聚合表';

CREATE TABLE `achievement` (
  `achievement_id` INT NOT NULL AUTO_INCREMENT COMMENT '成果ID',
  `teacher_id` INT NOT NULL COMMENT '教师ID',
  `name` VARCHAR(255) NOT NULL COMMENT '成果名称',
  `type` VARCHAR(50) DEFAULT NULL COMMENT '成果类型',
  `stat_year` INT DEFAULT NULL COMMENT '统计年份',
  `unit_count` INT DEFAULT NULL COMMENT '参与单位数',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`achievement_id`),
  KEY `idx_achievement_teacher_id` (`teacher_id`),
  CONSTRAINT `fk_achievement_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成果表';

CREATE TABLE `indicator_rule` (
  `rule_id` INT NOT NULL AUTO_INCREMENT COMMENT '规则ID',
  `indicator_code` VARCHAR(64) NOT NULL COMMENT '指标编码',
  `indicator_name` VARCHAR(128) NOT NULL COMMENT '指标名称',
  `weight` DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT '指标权重',
  `compare_type` VARCHAR(8) NOT NULL COMMENT '比较方式 LT/GT',
  `threshold_value` DECIMAL(10,2) NOT NULL COMMENT '阈值',
  `enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `remark` VARCHAR(255) DEFAULT NULL COMMENT '备注',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`rule_id`),
  UNIQUE KEY `uk_indicator_rule_code` (`indicator_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标规则表';

CREATE TABLE `warning_record` (
  `warning_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '预警ID',
  `major_id` INT NOT NULL COMMENT '专业ID',
  `indicator_code` VARCHAR(64) NOT NULL COMMENT '指标编码',
  `indicator_name` VARCHAR(128) NOT NULL COMMENT '指标名称',
  `stat_year` INT NOT NULL COMMENT '统计年份',
  `compare_type` VARCHAR(8) NOT NULL COMMENT '比较方式',
  `threshold_value` DECIMAL(10,2) NOT NULL COMMENT '阈值',
  `actual_value` DECIMAL(10,2) NOT NULL COMMENT '实际值',
  `status` VARCHAR(16) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态',
  `message` VARCHAR(255) DEFAULT NULL COMMENT '提示信息',
  `triggered_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '触发时间',
  `cleared_at` DATETIME DEFAULT NULL COMMENT '解除时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`warning_id`),
  KEY `idx_warning_major_year` (`major_id`, `stat_year`),
  CONSTRAINT `fk_warning_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预警记录表';

CREATE TABLE `report_template` (
  `template_id` INT NOT NULL AUTO_INCREMENT COMMENT '模板ID',
  `name` VARCHAR(255) NOT NULL COMMENT '模板名称',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '模板描述',
  `format` VARCHAR(50) DEFAULT NULL COMMENT '导出格式',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`template_id`),
  UNIQUE KEY `uk_report_template_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='报表模板表';

CREATE TABLE `import_task` (
  `task_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `task_type` VARCHAR(64) NOT NULL COMMENT '任务类型',
  `file_name` VARCHAR(255) NOT NULL COMMENT '文件名',
  `status` VARCHAR(16) NOT NULL COMMENT '任务状态',
  `total_rows` INT NOT NULL DEFAULT 0 COMMENT '总行数',
  `success_rows` INT NOT NULL DEFAULT 0 COMMENT '成功行数',
  `fail_rows` INT NOT NULL DEFAULT 0 COMMENT '失败行数',
  `error_message` VARCHAR(1000) DEFAULT NULL COMMENT '错误信息',
  `operator_user_id` BIGINT DEFAULT NULL COMMENT '操作人',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='导入任务表';

CREATE TABLE `operation_log` (
  `log_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `username` VARCHAR(64) DEFAULT NULL COMMENT '用户名',
  `module` VARCHAR(64) DEFAULT NULL COMMENT '模块',
  `operation` VARCHAR(64) DEFAULT NULL COMMENT '操作',
  `request_method` VARCHAR(16) DEFAULT NULL COMMENT '请求方式',
  `request_uri` VARCHAR(255) DEFAULT NULL COMMENT '请求地址',
  `request_body` VARCHAR(2000) DEFAULT NULL COMMENT '请求体摘要',
  `success` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否成功',
  `error_message` VARCHAR(1000) DEFAULT NULL COMMENT '错误信息',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

SET FOREIGN_KEY_CHECKS = 1;
