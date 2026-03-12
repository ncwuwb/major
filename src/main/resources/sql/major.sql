/*
 Navicat Premium Dump SQL

 Source Server         : wwb
 Source Server Type    : MySQL
 Source Server Version : 80026 (8.0.26)
 Source Host           : localhost:3306
 Source Schema         : major

 Target Server Type    : MySQL
 Target Server Version : 80026 (8.0.26)
 File Encoding         : 65001

 Date: 12/03/2026 19:01:17
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for achievement
-- ----------------------------
DROP TABLE IF EXISTS `achievement`;
CREATE TABLE `achievement`  (
  `achievement_id` int NOT NULL AUTO_INCREMENT COMMENT '成果ID',
  `teacher_id` int NOT NULL COMMENT '教师ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '成果名称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '成果类型',
  `stat_year` int NULL DEFAULT NULL COMMENT '统计年份',
  `unit_count` int NULL DEFAULT NULL COMMENT '参与单位数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`achievement_id`) USING BTREE,
  INDEX `idx_achievement_teacher_id`(`teacher_id` ASC) USING BTREE,
  CONSTRAINT `fk_achievement_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '成果表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of achievement
-- ----------------------------
INSERT INTO `achievement` VALUES (1, 1, '基于临床护理能力培养的课程改革', '教学项目', 2024, 2, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `achievement` VALUES (2, 1, '护理技能竞赛指导成果', '获奖', 2025, 1, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `achievement` VALUES (3, 4, '智慧检验实验课程建设', '论文', 2024, 3, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `achievement` VALUES (4, 4, '医学检验人才培养模式研究', '科研项目', 2025, 2, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for admission
-- ----------------------------
DROP TABLE IF EXISTS `admission`;
CREATE TABLE `admission`  (
  `admission_id` int NOT NULL AUTO_INCREMENT COMMENT '招生ID',
  `major_id` int NOT NULL COMMENT '所属专业ID',
  `stat_year` int NOT NULL COMMENT '统计年份',
  `plan_count` int NULL DEFAULT NULL COMMENT '计划人数',
  `actual_count` int NULL DEFAULT NULL COMMENT '录取人数',
  `min_score` decimal(5, 2) NULL DEFAULT NULL COMMENT '最低分',
  `max_score` decimal(5, 2) NULL DEFAULT NULL COMMENT '最高分',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`admission_id`) USING BTREE,
  UNIQUE INDEX `uk_admission_major_year`(`major_id` ASC, `stat_year` ASC) USING BTREE,
  CONSTRAINT `fk_admission_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '招生录取表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admission
-- ----------------------------
INSERT INTO `admission` VALUES (1, 1, 2024, 120, 114, 520.00, 589.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `admission` VALUES (2, 2, 2024, 80, 70, 505.00, 560.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `admission` VALUES (3, 3, 2024, 90, 88, 510.00, 578.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `admission` VALUES (4, 1, 2025, 130, 128, 525.00, 592.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `admission` VALUES (5, 2, 2025, 90, 76, 506.00, 565.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `admission` VALUES (6, 3, 2025, 95, 92, 514.00, 581.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for campus
-- ----------------------------
DROP TABLE IF EXISTS `campus`;
CREATE TABLE `campus`  (
  `campus_id` int NOT NULL AUTO_INCREMENT COMMENT '校区ID',
  `school_id` int NOT NULL COMMENT '所属学校ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '校区名称',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '城市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区县',
  `is_main` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否主校区',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`campus_id`) USING BTREE,
  INDEX `idx_campus_school_id`(`school_id` ASC) USING BTREE,
  CONSTRAINT `fk_campus_school` FOREIGN KEY (`school_id`) REFERENCES `school` (`school_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '校区信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of campus
-- ----------------------------
INSERT INTO `campus` VALUES (1, 1, '主校区', '江苏省', '南京市', '江宁区', 1, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `campus` VALUES (2, 1, '临床校区', '江苏省', '南京市', '鼓楼区', 0, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for competition
-- ----------------------------
DROP TABLE IF EXISTS `competition`;
CREATE TABLE `competition`  (
  `competition_id` int NOT NULL AUTO_INCREMENT COMMENT '竞赛ID',
  `student_id` int NOT NULL COMMENT '学生ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '竞赛名称',
  `level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '竞赛级别',
  `award` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '获奖情况',
  `stat_year` int NULL DEFAULT NULL COMMENT '统计年份',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`competition_id`) USING BTREE,
  INDEX `idx_competition_student_id`(`student_id` ASC) USING BTREE,
  CONSTRAINT `fk_competition_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '竞赛获奖表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of competition
-- ----------------------------
INSERT INTO `competition` VALUES (1, 1, '全国护理技能大赛', '国家级', '二等奖', 2024, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `competition` VALUES (2, 3, '省级助产技能竞赛', '省级', '一等奖', 2024, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `competition` VALUES (3, 5, '医学检验技能竞赛', '国家级', '三等奖', 2025, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `competition` VALUES (4, 6, '大学生创新创业竞赛', '省级', '二等奖', 2025, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `course_id` int NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `major_id` int NOT NULL COMMENT '所属专业ID',
  `course_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '课程代码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '课程名称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '课程类型',
  `credits` decimal(4, 1) NULL DEFAULT NULL COMMENT '学分',
  `semester` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '开课学期',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`course_id`) USING BTREE,
  UNIQUE INDEX `uk_course_code`(`course_code` ASC) USING BTREE,
  INDEX `idx_course_major_id`(`major_id` ASC) USING BTREE,
  CONSTRAINT `fk_course_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, 1, 'C001', '基础护理学', '必修', 4.0, '第3学期', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `course` VALUES (2, 1, 'C002', '内科护理学', '必修', 3.5, '第5学期', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `course` VALUES (3, 2, 'C003', '助产技术', '必修', 3.0, '第4学期', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `course` VALUES (4, 2, 'C004', '围产保健', '选修', 2.0, '第5学期', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `course` VALUES (5, 3, 'C005', '临床检验基础', '必修', 4.0, '第3学期', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `course` VALUES (6, 3, 'C006', '微生物检验', '必修', 3.0, '第5学期', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `dept_id` int NOT NULL AUTO_INCREMENT COMMENT '学院ID',
  `school_id` int NOT NULL COMMENT '所属学校ID',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学院编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学院名称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位类型',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`dept_id`) USING BTREE,
  UNIQUE INDEX `uk_department_code`(`code` ASC) USING BTREE,
  INDEX `idx_department_school_id`(`school_id` ASC) USING BTREE,
  CONSTRAINT `fk_department_school` FOREIGN KEY (`school_id`) REFERENCES `school` (`school_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学院信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES (1, 1, 'DEP001', '护理学院', '学院', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `department` VALUES (2, 1, 'DEP002', '医学技术学院', '学院', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for experiment_base
-- ----------------------------
DROP TABLE IF EXISTS `experiment_base`;
CREATE TABLE `experiment_base`  (
  `base_id` int NOT NULL AUTO_INCREMENT COMMENT '实验基地ID',
  `major_id` int NOT NULL COMMENT '所属专业ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '基地名称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '基地类型',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '基地地址',
  `capacity` int NULL DEFAULT NULL COMMENT '容纳人数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`base_id`) USING BTREE,
  INDEX `idx_experiment_base_major_id`(`major_id` ASC) USING BTREE,
  CONSTRAINT `fk_experiment_base_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '实验基地表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of experiment_base
-- ----------------------------
INSERT INTO `experiment_base` VALUES (1, 1, '护理实训中心', '校内', '主校区实验楼', 120, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `experiment_base` VALUES (2, 2, '妇产科实践基地', '附属医院', '附属医院住院部', 60, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `experiment_base` VALUES (3, 3, '医学检验实训室', '校内', '临床校区检验楼', 90, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for experimentbase
-- ----------------------------
DROP TABLE IF EXISTS `experimentbase`;
CREATE TABLE `experimentbase`  (
  `base_id` int NOT NULL AUTO_INCREMENT COMMENT '实验基地ID',
  `major_id` int NOT NULL COMMENT '所属专业ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '基地名称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '基地类型',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '基地地址',
  `capacity` int NULL DEFAULT NULL COMMENT '容纳人数/容量',
  PRIMARY KEY (`base_id`) USING BTREE,
  INDEX `major_id`(`major_id` ASC) USING BTREE,
  CONSTRAINT `experimentbase_ibfk_1` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '专业实验与实训基地表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of experimentbase
-- ----------------------------

-- ----------------------------
-- Table structure for funding
-- ----------------------------
DROP TABLE IF EXISTS `funding`;
CREATE TABLE `funding`  (
  `funding_id` int NOT NULL AUTO_INCREMENT COMMENT '经费ID',
  `major_id` int NOT NULL COMMENT '所属专业ID',
  `stat_year` int NOT NULL COMMENT '统计年份',
  `allocated` decimal(12, 2) NULL DEFAULT NULL COMMENT '分配经费',
  `spent` decimal(12, 2) NULL DEFAULT NULL COMMENT '已使用经费',
  `utilization_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '使用率',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`funding_id`) USING BTREE,
  UNIQUE INDEX `uk_funding_major_year`(`major_id` ASC, `stat_year` ASC) USING BTREE,
  CONSTRAINT `fk_funding_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '专业经费表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of funding
-- ----------------------------
INSERT INTO `funding` VALUES (1, 1, 2024, 220.00, 180.00, 81.82, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `funding` VALUES (2, 2, 2024, 160.00, 98.00, 61.25, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `funding` VALUES (3, 3, 2024, 190.00, 154.00, 81.05, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `funding` VALUES (4, 1, 2025, 250.00, 205.00, 82.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `funding` VALUES (5, 2, 2025, 180.00, 115.00, 63.89, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `funding` VALUES (6, 3, 2025, 210.00, 175.00, 83.33, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for graduate_outcome
-- ----------------------------
DROP TABLE IF EXISTS `graduate_outcome`;
CREATE TABLE `graduate_outcome`  (
  `outcome_id` int NOT NULL AUTO_INCREMENT COMMENT '毕业去向ID',
  `major_id` int NOT NULL COMMENT '所属专业ID',
  `stat_year` int NOT NULL COMMENT '统计年份',
  `graduate_count` int NOT NULL DEFAULT 0 COMMENT '毕业人数',
  `employment_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '就业率',
  `postgraduate_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '升学率',
  `average_salary` decimal(10, 2) NULL DEFAULT NULL COMMENT '平均薪资',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`outcome_id`) USING BTREE,
  UNIQUE INDEX `uk_graduate_outcome_major_year`(`major_id` ASC, `stat_year` ASC) USING BTREE,
  CONSTRAINT `fk_graduate_outcome_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '毕业去向聚合表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of graduate_outcome
-- ----------------------------
INSERT INTO `graduate_outcome` VALUES (1, 1, 2024, 110, 92.50, 18.00, 6800.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `graduate_outcome` VALUES (2, 2, 2024, 72, 78.00, 12.00, 6100.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `graduate_outcome` VALUES (3, 3, 2024, 85, 88.00, 22.00, 7200.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `graduate_outcome` VALUES (4, 1, 2025, 118, 93.00, 19.00, 7100.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `graduate_outcome` VALUES (5, 2, 2025, 75, 79.50, 13.00, 6300.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `graduate_outcome` VALUES (6, 3, 2025, 90, 89.00, 24.00, 7500.00, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for import_task
-- ----------------------------
DROP TABLE IF EXISTS `import_task`;
CREATE TABLE `import_task`  (
  `task_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `task_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务类型',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件名',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务状态',
  `total_rows` int NOT NULL DEFAULT 0 COMMENT '总行数',
  `success_rows` int NOT NULL DEFAULT 0 COMMENT '成功行数',
  `fail_rows` int NOT NULL DEFAULT 0 COMMENT '失败行数',
  `error_message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '错误信息',
  `operator_user_id` bigint NULL DEFAULT NULL COMMENT '操作人',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`task_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '导入任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of import_task
-- ----------------------------

-- ----------------------------
-- Table structure for indicator_rule
-- ----------------------------
DROP TABLE IF EXISTS `indicator_rule`;
CREATE TABLE `indicator_rule`  (
  `rule_id` int NOT NULL AUTO_INCREMENT COMMENT '规则ID',
  `indicator_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '指标编码',
  `indicator_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '指标名称',
  `weight` decimal(5, 2) NOT NULL DEFAULT 0.00 COMMENT '指标权重',
  `compare_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '比较方式 LT/GT',
  `threshold_value` decimal(10, 2) NOT NULL COMMENT '阈值',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`rule_id`) USING BTREE,
  UNIQUE INDEX `uk_indicator_rule_code`(`indicator_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '指标规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of indicator_rule
-- ----------------------------
INSERT INTO `indicator_rule` VALUES (1, 'PHD_RATE', '博士占比', 20.00, 'LT', 40.00, 1, '低于40%触发预警', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `indicator_rule` VALUES (2, 'ADMISSION_COMPLETION_RATE', '招生完成率', 20.00, 'LT', 90.00, 1, '低于90%触发预警', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `indicator_rule` VALUES (3, 'FUNDING_UTILIZATION_RATE', '经费使用率', 20.00, 'LT', 70.00, 1, '低于70%触发预警', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `indicator_rule` VALUES (4, 'EMPLOYMENT_RATE', '就业率', 20.00, 'LT', 80.00, 1, '低于80%触发预警', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `indicator_rule` VALUES (5, 'POSTGRADUATE_RATE', '升学率', 20.00, 'LT', 15.00, 1, '低于15%触发预警', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for international_exchange
-- ----------------------------
DROP TABLE IF EXISTS `international_exchange`;
CREATE TABLE `international_exchange`  (
  `exchange_id` int NOT NULL AUTO_INCREMENT COMMENT '国际交流ID',
  `student_id` int NOT NULL COMMENT '学生ID',
  `program` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '交流项目',
  `stat_year` int NULL DEFAULT NULL COMMENT '统计年份',
  `outcome` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '交流成果',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`exchange_id`) USING BTREE,
  INDEX `idx_international_exchange_student_id`(`student_id` ASC) USING BTREE,
  CONSTRAINT `fk_exchange_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '国际交流表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of international_exchange
-- ----------------------------
INSERT INTO `international_exchange` VALUES (1, 2, '护理国际交流项目', 2024, '完成海外临床见习', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `international_exchange` VALUES (2, 5, '检验技术交流访问', 2025, '发表交流报告', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for internationalexchange
-- ----------------------------
DROP TABLE IF EXISTS `internationalexchange`;
CREATE TABLE `internationalexchange`  (
  `exchange_id` int NOT NULL AUTO_INCREMENT COMMENT '国际交流ID',
  `student_id` int NOT NULL COMMENT '学生ID',
  `program` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交流项目名称',
  `year` year NULL DEFAULT NULL COMMENT '交流年份',
  `outcome` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交流成果/论文发表',
  PRIMARY KEY (`exchange_id`) USING BTREE,
  INDEX `student_id`(`student_id` ASC) USING BTREE,
  CONSTRAINT `internationalexchange_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生国际交流信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of internationalexchange
-- ----------------------------

-- ----------------------------
-- Table structure for major
-- ----------------------------
DROP TABLE IF EXISTS `major`;
CREATE TABLE `major`  (
  `major_id` int NOT NULL AUTO_INCREMENT COMMENT '专业ID',
  `dept_id` int NOT NULL COMMENT '所属学院ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '专业名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '专业代码',
  `level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '培养层次',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '专业类别',
  `duration_years` int NULL DEFAULT NULL COMMENT '学制年限',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`major_id`) USING BTREE,
  UNIQUE INDEX `uk_major_code`(`code` ASC) USING BTREE,
  INDEX `idx_major_dept_id`(`dept_id` ASC) USING BTREE,
  CONSTRAINT `fk_major_department` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '专业信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of major
-- ----------------------------
INSERT INTO `major` VALUES (1, 1, '护理学', 'MAJ001', '本科', '医学', 4, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `major` VALUES (2, 1, '助产学', 'MAJ002', '本科', '医学', 4, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `major` VALUES (3, 2, '医学检验技术', 'MAJ003', '本科', '医学技术', 4, '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户名',
  `module` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模块',
  `operation` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求方式',
  `request_uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求地址',
  `request_body` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求体摘要',
  `success` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否成功',
  `error_message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '错误信息',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_log
-- ----------------------------

-- ----------------------------
-- Table structure for report_template
-- ----------------------------
DROP TABLE IF EXISTS `report_template`;
CREATE TABLE `report_template`  (
  `template_id` int NOT NULL AUTO_INCREMENT COMMENT '模板ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模板描述',
  `format` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '导出格式',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`template_id`) USING BTREE,
  UNIQUE INDEX `uk_report_template_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '报表模板表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of report_template
-- ----------------------------
INSERT INTO `report_template` VALUES (1, '专业年度总览', '用于导出专业年度指标汇总', 'EXCEL', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `report_template` VALUES (2, '预警清单', '用于导出当前预警记录', 'EXCEL', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for reporttemplate
-- ----------------------------
DROP TABLE IF EXISTS `reporttemplate`;
CREATE TABLE `reporttemplate`  (
  `template_id` int NOT NULL AUTO_INCREMENT COMMENT '模板ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模板描述',
  `format` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '报告格式（PDF/Excel）',
  PRIMARY KEY (`template_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '报表模板表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reporttemplate
-- ----------------------------

-- ----------------------------
-- Table structure for researchachievement
-- ----------------------------
DROP TABLE IF EXISTS `researchachievement`;
CREATE TABLE `researchachievement`  (
  `achievement_id` int NOT NULL AUTO_INCREMENT COMMENT '科研成果ID',
  `teacher_id` int NOT NULL COMMENT '教师ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '成果名称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '成果类型（论文/专著/获奖）',
  `year` year NULL DEFAULT NULL COMMENT '成果年份',
  `unit_count` int NULL DEFAULT NULL COMMENT '参与单位数',
  PRIMARY KEY (`achievement_id`) USING BTREE,
  INDEX `teacher_id`(`teacher_id` ASC) USING BTREE,
  CONSTRAINT `researchachievement_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '教师科研成果表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of researchachievement
-- ----------------------------

-- ----------------------------
-- Table structure for school
-- ----------------------------
DROP TABLE IF EXISTS `school`;
CREATE TABLE `school`  (
  `school_id` int NOT NULL AUTO_INCREMENT COMMENT '学校ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学校名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学校代码',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '办学类型',
  `nature` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学校性质',
  `level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学校层次或等级',
  `website` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学校网址',
  `contact_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人姓名',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人电话',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`school_id`) USING BTREE,
  UNIQUE INDEX `uk_school_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学校信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of school
-- ----------------------------
INSERT INTO `school` VALUES (1, '示例医科大学', 'SCH001', '本科', '公办', '省属重点', 'https://www.example.edu.cn', '张老师', '13800000001', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `student_id` int NOT NULL AUTO_INCREMENT COMMENT '学生ID',
  `major_id` int NOT NULL COMMENT '所属专业ID',
  `student_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学生姓名',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '性别',
  `enrollment_year` int NULL DEFAULT NULL COMMENT '入学年份',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '在校状态',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`student_id`) USING BTREE,
  UNIQUE INDEX `uk_student_no`(`student_no` ASC) USING BTREE,
  INDEX `idx_student_major_id`(`major_id` ASC) USING BTREE,
  CONSTRAINT `fk_student_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学生信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (1, 1, 'S001', '刘洋', 'M', 2022, '在校', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `student` VALUES (2, 1, 'S002', '孙悦', 'F', 2022, '在校', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `student` VALUES (3, 2, 'S003', '杨静', 'F', 2021, '在校', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `student` VALUES (4, 2, 'S004', '吴彤', 'F', 2021, '毕业', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `student` VALUES (5, 3, 'S005', '高翔', 'M', 2022, '在校', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `student` VALUES (6, 3, 'S006', '程琳', 'F', 2021, '毕业', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `real_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '真实姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `role_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色编码',
  `scope_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限范围类型',
  `scope_id` bigint NOT NULL COMMENT '权限范围ID',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `uk_sys_user_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '{bcrypt}$2a$10$aX9pFSMWNvBKq1e2gxfc2ODqSN9AsuxhGUzDWyWawjBvCwShpjiTa', '系统管理员', NULL, NULL, 'SCHOOL_ADMIN', 'SCHOOL', 1, 1, '2026-03-11 21:50:33', '2026-03-11 17:47:22', '2026-03-11 17:47:22', 0);

-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher`  (
  `teacher_id` int NOT NULL AUTO_INCREMENT COMMENT '教师ID',
  `dept_id` int NOT NULL COMMENT '所属学院ID',
  `teacher_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '教师工号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '教师姓名',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '职称',
  `degree` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学位',
  `phd_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否博士',
  `employment_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '聘用类型',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`teacher_id`) USING BTREE,
  UNIQUE INDEX `uk_teacher_no`(`teacher_no` ASC) USING BTREE,
  INDEX `idx_teacher_dept_id`(`dept_id` ASC) USING BTREE,
  CONSTRAINT `fk_teacher_department` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '教师信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES (1, 1, 'T001', '王芳', '教授', '博士', 1, '专任', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `teacher` VALUES (2, 1, 'T002', '李敏', '副教授', '硕士', 0, '专任', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `teacher` VALUES (3, 1, 'T003', '周洁', '讲师', '博士', 1, '兼职', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `teacher` VALUES (4, 2, 'T004', '陈涛', '教授', '博士', 1, '专任', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);
INSERT INTO `teacher` VALUES (5, 2, 'T005', '赵蕾', '副教授', '硕士', 0, '校外导师', '2026-03-11 17:45:49', '2026-03-11 17:45:49', 0);

-- ----------------------------
-- Table structure for warning_record
-- ----------------------------
DROP TABLE IF EXISTS `warning_record`;
CREATE TABLE `warning_record`  (
  `warning_id` bigint NOT NULL AUTO_INCREMENT COMMENT '预警ID',
  `major_id` int NOT NULL COMMENT '专业ID',
  `indicator_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '指标编码',
  `indicator_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '指标名称',
  `stat_year` int NOT NULL COMMENT '统计年份',
  `compare_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '比较方式',
  `threshold_value` decimal(10, 2) NOT NULL COMMENT '阈值',
  `actual_value` decimal(10, 2) NOT NULL COMMENT '实际值',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态',
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提示信息',
  `triggered_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '触发时间',
  `cleared_at` datetime NULL DEFAULT NULL COMMENT '解除时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`warning_id`) USING BTREE,
  INDEX `idx_warning_major_year`(`major_id` ASC, `stat_year` ASC) USING BTREE,
  CONSTRAINT `fk_warning_major` FOREIGN KEY (`major_id`) REFERENCES `major` (`major_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预警记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of warning_record
-- ----------------------------
INSERT INTO `warning_record` VALUES (1, 2, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2024, 'LT', 90.00, 87.50, 'ACTIVE', '招生完成率 actual 87.50 threshold 90.00', '2026-03-11 21:52:19', NULL, '2026-03-11 21:52:19', '2026-03-11 21:52:19', 0);
INSERT INTO `warning_record` VALUES (2, 2, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2024, 'LT', 70.00, 61.25, 'ACTIVE', '经费使用率 actual 61.25 threshold 70.00', '2026-03-11 21:52:19', NULL, '2026-03-11 21:52:19', '2026-03-11 21:52:19', 0);
INSERT INTO `warning_record` VALUES (3, 2, 'EMPLOYMENT_RATE', '就业率', 2024, 'LT', 80.00, 78.00, 'ACTIVE', '就业率 actual 78.00 threshold 80.00', '2026-03-11 21:52:19', NULL, '2026-03-11 21:52:19', '2026-03-11 21:52:19', 0);
INSERT INTO `warning_record` VALUES (4, 2, 'POSTGRADUATE_RATE', '升学率', 2024, 'LT', 15.00, 12.00, 'ACTIVE', '升学率 actual 12.00 threshold 15.00', '2026-03-11 21:52:19', NULL, '2026-03-11 21:52:19', '2026-03-11 21:52:19', 0);
INSERT INTO `warning_record` VALUES (5, 2, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2025, 'LT', 90.00, 84.44, 'ACTIVE', '招生完成率 actual 84.44 threshold 90.00', '2026-03-11 21:52:19', NULL, '2026-03-11 21:52:19', '2026-03-11 21:52:19', 0);
INSERT INTO `warning_record` VALUES (6, 2, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2025, 'LT', 70.00, 63.89, 'ACTIVE', '经费使用率 actual 63.89 threshold 70.00', '2026-03-11 21:52:19', NULL, '2026-03-11 21:52:19', '2026-03-11 21:52:19', 0);
INSERT INTO `warning_record` VALUES (7, 2, 'EMPLOYMENT_RATE', '就业率', 2025, 'LT', 80.00, 79.50, 'ACTIVE', '就业率 actual 79.50 threshold 80.00', '2026-03-11 21:52:19', NULL, '2026-03-11 21:52:19', '2026-03-11 21:52:19', 0);
INSERT INTO `warning_record` VALUES (8, 2, 'POSTGRADUATE_RATE', '升学率', 2025, 'LT', 15.00, 13.00, 'ACTIVE', '升学率 actual 13.00 threshold 15.00', '2026-03-11 21:52:19', NULL, '2026-03-11 21:52:19', '2026-03-11 21:52:19', 0);

SET FOREIGN_KEY_CHECKS = 1;
