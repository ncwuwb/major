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

 Date: 03/05/2026 16:05:26
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
) ENGINE = InnoDB AUTO_INCREMENT = 56 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '成果表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of achievement
-- ----------------------------
INSERT INTO `achievement` VALUES (1, 1, '基于临床护理能力培养的课程改革', '教学项目', 2021, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (2, 9, '医学检验新技术应用研究', '论文', 2021, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (3, 19, '公共卫生应急管理体系研究', '科研项目', 2021, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (4, 21, '流行病学大数据分析平台建设', '教学项目', 2021, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (5, 28, '新型药物递送系统研发', '论文', 2021, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (6, 1, '护理技能竞赛指导成果', '获奖', 2022, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (7, 3, '社区护理服务模式创新研究', '论文', 2022, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (8, 9, '智慧检验实验课程建设', '教学项目', 2022, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (9, 13, '医学影像AI辅助诊断研究', '科研项目', 2022, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (10, 19, '城市社区健康监测研究', '论文', 2022, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (11, 20, '疫苗接种效果评价研究', '论文', 2022, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (12, 28, '天然药物活性成分提取工艺', '专利', 2022, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (13, 32, '药物代谢动力学模型构建', '科研项目', 2022, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (14, 1, '老年护理教育改革实践', '教学项目', 2023, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (15, 6, '护理学精品课程建设', '获奖', 2023, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (16, 9, '临床检验自动化系统优化', '科研项目', 2023, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (17, 11, '生化检验新方法学研究', '论文', 2023, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (18, 13, 'CT影像重建算法研究', '论文', 2023, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (19, 19, '职业病危害因素监测与防控', '科研项目', 2023, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (20, 21, '环境污染物健康效应研究', '论文', 2023, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (21, 23, '食品安全快速检测技术', '专利', 2023, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (22, 28, '抗肿瘤药物筛选平台', '科研项目', 2023, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (23, 30, '中药质量标准化研究', '论文', 2023, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (24, 34, '药物晶型研究与应用', '论文', 2023, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (25, 1, '护理学虚拟仿真实验建设', '教学项目', 2024, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (26, 3, '重症护理指南编写', '教材', 2024, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (27, 6, '急诊护理技能培训体系', '教学项目', 2024, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (28, 9, '医学检验质量控制体系研究', '论文', 2024, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (29, 11, '免疫学检验新进展综述', '论文', 2024, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (30, 13, 'MRI功能成像技术应用', '科研项目', 2024, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (31, 16, '分子诊断学教材编写', '教材', 2024, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (32, 19, '公共卫生大数据预警系统', '科研项目', 2024, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (33, 20, '社区慢性病管理研究', '论文', 2024, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (34, 21, '水质安全评估技术开发', '专利', 2024, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (35, 25, '营养与慢性病关系研究', '论文', 2024, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (36, 28, '新型制剂技术研发', '科研项目', 2024, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (37, 30, '中药药理学研究进展', '论文', 2024, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (38, 32, '药物基因组学应用研究', '科研项目', 2024, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (39, 1, '护理学一流课程建设成果', '获奖', 2025, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (40, 3, '精准护理技术应用研究', '论文', 2025, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (41, 6, '智能护理教学平台开发', '科研项目', 2025, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (42, 4, '护理心理学课程创新', '教学项目', 2025, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (43, 9, '智慧实验室信息管理系统', '科研项目', 2025, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (44, 11, '基因检测技术临床应用', '论文', 2025, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (45, 13, '人工智能影像诊断系统', '获奖', 2025, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (46, 16, '医学技术综合实验改革', '教学项目', 2025, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (47, 19, '传染病防控策略研究', '科研项目', 2025, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (48, 20, '健康中国战略实施评估', '论文', 2025, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (49, 21, '全球卫生治理研究', '论文', 2025, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (50, 23, '生物样本库建设方案', '科研项目', 2025, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (51, 28, '靶向药物设计与合成', '论文', 2025, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (52, 30, '中药资源开发利用研究', '科研项目', 2025, 3, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (53, 32, '药物制剂新技术应用', '专利', 2025, 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (54, 34, '药品质量检测标准研制', '论文', 2025, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `achievement` VALUES (55, 29, '药物安全性评价研究', '科研项目', 2025, 2, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '招生录取表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admission
-- ----------------------------
INSERT INTO `admission` VALUES (1, 1, 2021, 100, 90, 498.50, 556.20, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (2, 1, 2022, 108, 99, 503.80, 565.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (3, 1, 2023, 112, 105, 510.20, 571.80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (4, 1, 2024, 120, 114, 518.50, 585.60, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (5, 1, 2025, 125, 121, 525.30, 595.20, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (6, 2, 2021, 55, 42, 470.20, 520.80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (7, 2, 2022, 60, 48, 475.50, 528.30, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (8, 2, 2023, 65, 54, 480.80, 535.60, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (9, 2, 2024, 70, 60, 486.20, 542.80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (10, 2, 2025, 75, 65, 490.50, 548.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (11, 3, 2021, 80, 72, 510.50, 568.30, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (12, 3, 2022, 85, 78, 515.80, 575.60, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (13, 3, 2023, 88, 82, 520.20, 580.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (14, 3, 2024, 90, 86, 525.80, 588.20, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (15, 3, 2025, 95, 92, 530.50, 595.80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (16, 4, 2021, 90, 80, 505.20, 560.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (17, 4, 2022, 95, 87, 510.50, 568.80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (18, 4, 2023, 98, 91, 515.80, 575.20, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (19, 4, 2024, 100, 95, 520.50, 582.60, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (20, 4, 2025, 105, 101, 528.20, 590.80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (21, 5, 2021, 70, 60, 490.80, 548.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (22, 5, 2022, 72, 64, 496.20, 555.80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (23, 5, 2023, 75, 68, 500.50, 562.30, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (24, 5, 2024, 78, 73, 506.80, 570.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (25, 5, 2025, 80, 76, 512.50, 578.20, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (26, 6, 2021, 50, 38, 465.50, 515.20, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (27, 6, 2022, 52, 42, 470.80, 522.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (28, 6, 2023, 55, 46, 476.20, 528.80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (29, 6, 2024, 58, 50, 480.50, 535.20, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (30, 6, 2025, 60, 52, 485.80, 542.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (31, 7, 2021, 85, 78, 520.50, 575.80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (32, 7, 2022, 88, 82, 525.80, 582.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (33, 7, 2023, 92, 87, 530.20, 588.80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (34, 7, 2024, 95, 91, 536.50, 596.20, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (35, 7, 2025, 100, 97, 542.80, 605.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (36, 8, 2021, 60, 50, 480.50, 535.20, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (37, 8, 2022, 62, 53, 485.80, 542.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (38, 8, 2023, 65, 58, 490.20, 548.80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (39, 8, 2024, 68, 62, 495.50, 555.20, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `admission` VALUES (40, 8, 2025, 70, 65, 502.80, 565.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '校区信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of campus
-- ----------------------------
INSERT INTO `campus` VALUES (1, 1, '主校区', '江苏省', '南京市', '江宁区', 1, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `campus` VALUES (2, 1, '临床校区', '江苏省', '南京市', '鼓楼区', 0, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '竞赛获奖表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of competition
-- ----------------------------
INSERT INTO `competition` VALUES (1, 1, '全国护理技能大赛', '国家级', '二等奖', 2021, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (2, 19, '全国医学检验技能竞赛', '国家级', '三等奖', 2021, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (3, 39, '全国公共卫生案例分析赛', '国家级', '优秀奖', 2021, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (4, 57, '全国药学实验技能大赛', '国家级', '三等奖', 2021, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (5, 2, '省级护理技能竞赛', '省级', '一等奖', 2022, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (6, 11, '省级助产技能竞赛', '省级', '二等奖', 2022, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (7, 20, '省级检验技能竞赛', '省级', '一等奖', 2022, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (8, 29, '全国医学影像技术竞赛', '国家级', '三等奖', 2022, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (9, 40, '省级流行病学调查竞赛', '省级', '一等奖', 2022, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (10, 49, '省级卫生检验技能赛', '省级', '二等奖', 2022, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (11, 58, '省级药学实验竞赛', '省级', '一等奖', 2022, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (12, 3, '全国护理创新大赛', '国家级', '一等奖', 2023, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (13, 4, '省级护理技能竞赛', '省级', '一等奖', 2023, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (14, 12, '全国助产技能竞赛', '国家级', '三等奖', 2023, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (15, 21, '全国生化检验技能赛', '国家级', '二等奖', 2023, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (16, 30, '省级影像技术创新赛', '省级', '一等奖', 2023, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (17, 41, '全国卫生统计分析竞赛', '国家级', '二等奖', 2023, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (18, 42, '省级健康教育方案设计赛', '省级', '二等奖', 2023, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (19, 50, '省级食品安全检测赛', '省级', '一等奖', 2023, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (20, 59, '全国药物制剂创新大赛', '国家级', '一等奖', 2023, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (21, 67, '省级中药鉴定竞赛', '省级', '二等奖', 2023, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (22, 5, '全国护理技能大赛', '国家级', '二等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (23, 6, '省级急救护理竞赛', '省级', '一等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (24, 13, '省级妇幼保健技能赛', '省级', '一等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (25, 14, '大学生创新创业竞赛', '省级', '二等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (26, 22, '全国检验技能竞赛', '国家级', '一等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (27, 23, '省级免疫学检验赛', '省级', '二等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (28, 31, '全国影像技能大赛', '国家级', '二等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (29, 43, '全国公共卫生创新赛', '国家级', '一等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (30, 44, '省级环境卫生方案赛', '省级', '一等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (31, 51, '全国卫生检验竞赛', '国家级', '三等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (32, 60, '全国药学知识竞赛', '国家级', '二等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (33, 61, '省级药物分析竞赛', '省级', '一等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (34, 68, '全国中药学知识竞赛', '国家级', '三等奖', 2024, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (35, 7, '全国护理创新大赛', '国家级', '一等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (36, 8, '省级社区护理竞赛', '省级', '一等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (37, 9, '互联网+大学生创新创业大赛', '国家级', '铜奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (38, 15, '全国助产技能大赛', '国家级', '二等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (39, 16, '省级母婴护理竞赛', '省级', '一等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (40, 24, '全国检验医学创新赛', '国家级', '一等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (41, 25, '省级分子诊断竞赛', '省级', '一等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (42, 32, '全国影像技术创新赛', '国家级', '一等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (43, 33, '省级超声诊断竞赛', '省级', '二等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (44, 45, '全国卫生应急技能赛', '国家级', '二等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (45, 46, '省级营养与食品安全赛', '省级', '一等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (46, 52, '全国检验检疫技能赛', '国家级', '二等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (47, 62, '全国药学创新创业大赛', '国家级', '一等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (48, 63, '省级临床药学竞赛', '省级', '一等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (49, 69, '全国中药技能大赛', '国家级', '二等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `competition` VALUES (50, 70, '省级中药炮制竞赛', '省级', '一等奖', 2025, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, 1, 'C001', '基础护理学', '必修', 4.0, '第3学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (2, 1, 'C002', '内科护理学', '必修', 3.5, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (3, 1, 'C003', '外科护理学', '必修', 3.5, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (4, 1, 'C004', '护理心理学', '选修', 2.0, '第4学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (5, 1, 'C005', '社区护理学', '必修', 2.5, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (6, 1, 'C006', '护理管理学', '选修', 2.0, '第7学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (7, 2, 'C007', '助产技术', '必修', 3.0, '第4学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (8, 2, 'C008', '围产保健', '选修', 2.0, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (9, 2, 'C009', '妇产科护理', '必修', 3.5, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (10, 2, 'C010', '新生儿护理', '必修', 2.5, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (11, 2, 'C011', '母婴保健', '选修', 2.0, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (12, 3, 'C012', '临床检验基础', '必修', 4.0, '第3学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (13, 3, 'C013', '微生物检验', '必修', 3.0, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (14, 3, 'C014', '生物化学检验', '必修', 3.5, '第4学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (15, 3, 'C015', '血液学检验', '必修', 3.0, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (16, 3, 'C016', '免疫学检验', '必修', 3.0, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (17, 3, 'C017', '分子诊断学', '选修', 2.0, '第7学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (18, 4, 'C018', '医学影像诊断学', '必修', 4.0, '第4学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (19, 4, 'C019', 'CT诊断技术', '必修', 3.0, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (20, 4, 'C020', 'MRI技术', '必修', 3.0, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (21, 4, 'C021', '超声诊断学', '必修', 3.0, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (22, 4, 'C022', '放射物理学', '选修', 2.0, '第3学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (23, 4, 'C023', '影像设备学', '选修', 2.0, '第7学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (24, 5, 'C024', '流行病学', '必修', 4.0, '第4学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (25, 5, 'C025', '卫生统计学', '必修', 3.5, '第3学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (26, 5, 'C026', '环境卫生学', '必修', 3.0, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (27, 5, 'C027', '营养与食品卫生', '必修', 3.0, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (28, 5, 'C028', '职业卫生学', '必修', 2.5, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (29, 5, 'C029', '卫生毒理学', '选修', 2.0, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (30, 5, 'C030', '健康教育学', '选修', 2.0, '第7学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (31, 6, 'C031', '卫生检验综合', '必修', 4.0, '第4学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (32, 6, 'C032', '食品理化检验', '必修', 3.0, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (33, 6, 'C033', '空气理化检验', '必修', 2.5, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (34, 6, 'C034', '水质检验', '必修', 2.5, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (35, 6, 'C035', '卫生微生物学', '选修', 2.0, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (36, 7, 'C036', '药理学', '必修', 4.0, '第3学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (37, 7, 'C037', '药物化学', '必修', 3.5, '第4学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (38, 7, 'C038', '药剂学', '必修', 3.5, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (39, 7, 'C039', '药物分析', '必修', 3.0, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (40, 7, 'C040', '临床药学', '必修', 2.5, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (41, 7, 'C041', '生药学', '选修', 2.0, '第4学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (42, 7, 'C042', '药事管理学', '选修', 2.0, '第7学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (43, 8, 'C043', '中药学概论', '必修', 3.5, '第3学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (44, 8, 'C044', '中药鉴定学', '必修', 3.0, '第4学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (45, 8, 'C045', '中药炮制学', '必修', 3.0, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (46, 8, 'C046', '中药药理学', '必修', 3.0, '第5学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (47, 8, 'C047', '方剂学', '选修', 2.5, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `course` VALUES (48, 8, 'C048', '中药制剂学', '选修', 2.0, '第6学期', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学院信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES (1, 1, 'DEP001', '护理学院', '学院', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `department` VALUES (2, 1, 'DEP002', '医学技术学院', '学院', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `department` VALUES (3, 1, 'DEP003', '公共卫生学院', '学院', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `department` VALUES (4, 1, 'DEP004', '药学院', '学院', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '实验基地表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of experiment_base
-- ----------------------------
INSERT INTO `experiment_base` VALUES (1, 1, '护理实训中心', '校内', '主校区实验楼A区', 120, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `experiment_base` VALUES (2, 2, '妇产科实践基地', '附属医院', '附属医院住院部', 60, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `experiment_base` VALUES (3, 3, '医学检验实训室', '校内', '临床校区检验楼', 90, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `experiment_base` VALUES (4, 4, '医学影像实训中心', '校内', '临床校区影像楼', 80, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `experiment_base` VALUES (5, 5, '公共卫生实验室', '校内', '主校区实验楼B区', 70, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `experiment_base` VALUES (6, 6, '卫生检验实训室', '校内', '主校区实验楼C区', 50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `experiment_base` VALUES (7, 7, '药学实验中心', '校内', '药学楼', 100, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `experiment_base` VALUES (8, 8, '中药标本馆', '校内', '药学楼B区', 60, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '专业实验与实训基地表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '专业经费表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of funding
-- ----------------------------
INSERT INTO `funding` VALUES (1, 1, 2021, 180.00, 130.00, 72.22, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (2, 1, 2022, 195.00, 148.00, 75.90, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (3, 1, 2023, 210.00, 168.00, 80.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (4, 1, 2024, 220.00, 182.00, 82.73, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (5, 1, 2025, 235.00, 200.00, 85.11, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (6, 2, 2021, 100.00, 55.00, 55.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (7, 2, 2022, 110.00, 64.00, 58.18, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (8, 2, 2023, 120.00, 74.00, 61.67, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (9, 2, 2024, 130.00, 84.00, 64.62, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (10, 2, 2025, 140.00, 94.00, 67.14, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (11, 3, 2021, 160.00, 112.00, 70.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (12, 3, 2022, 170.00, 125.00, 73.53, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (13, 3, 2023, 180.00, 140.00, 77.78, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (14, 3, 2024, 190.00, 155.00, 81.58, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (15, 3, 2025, 200.00, 170.00, 85.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (16, 4, 2021, 200.00, 150.00, 75.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (17, 4, 2022, 215.00, 168.00, 78.14, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (18, 4, 2023, 225.00, 182.00, 80.89, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (19, 4, 2024, 240.00, 200.00, 83.33, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (20, 4, 2025, 250.00, 215.00, 86.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (21, 5, 2021, 150.00, 105.00, 70.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (22, 5, 2022, 160.00, 118.00, 73.75, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (23, 5, 2023, 170.00, 132.00, 77.65, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (24, 5, 2024, 180.00, 148.00, 82.22, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (25, 5, 2025, 190.00, 162.00, 85.26, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (26, 6, 2021, 90.00, 48.00, 53.33, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (27, 6, 2022, 95.00, 55.00, 57.89, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (28, 6, 2023, 100.00, 63.00, 63.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (29, 6, 2024, 108.00, 72.00, 66.67, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (30, 6, 2025, 115.00, 78.00, 67.83, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (31, 7, 2021, 220.00, 165.00, 75.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (32, 7, 2022, 235.00, 185.00, 78.72, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (33, 7, 2023, 250.00, 205.00, 82.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (34, 7, 2024, 260.00, 220.00, 84.62, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (35, 7, 2025, 280.00, 245.00, 87.50, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (36, 8, 2021, 130.00, 88.00, 67.69, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (37, 8, 2022, 140.00, 100.00, 71.43, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (38, 8, 2023, 150.00, 112.00, 74.67, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (39, 8, 2024, 160.00, 125.00, 78.13, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `funding` VALUES (40, 8, 2025, 170.00, 140.00, 82.35, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '毕业去向聚合表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of graduate_outcome
-- ----------------------------
INSERT INTO `graduate_outcome` VALUES (1, 1, 2021, 85, 88.50, 15.20, 5800.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (2, 1, 2022, 90, 90.20, 16.50, 6200.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (3, 1, 2023, 95, 91.80, 17.80, 6600.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (4, 1, 2024, 100, 93.20, 18.50, 6900.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (5, 1, 2025, 105, 94.50, 19.20, 7200.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (6, 2, 2021, 38, 72.50, 8.20, 5200.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (7, 2, 2022, 40, 74.80, 9.50, 5500.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (8, 2, 2023, 42, 76.20, 10.80, 5800.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (9, 2, 2024, 45, 78.50, 11.50, 6000.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (10, 2, 2025, 48, 79.80, 12.20, 6200.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (11, 3, 2021, 65, 85.20, 20.50, 6500.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (12, 3, 2022, 68, 87.50, 22.00, 6800.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (13, 3, 2023, 72, 88.80, 23.50, 7100.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (14, 3, 2024, 75, 90.20, 24.80, 7400.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (15, 3, 2025, 80, 91.50, 26.00, 7700.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (16, 4, 2021, 75, 86.00, 18.20, 6300.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (17, 4, 2022, 78, 87.80, 19.50, 6600.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (18, 4, 2023, 82, 89.50, 20.80, 6900.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (19, 4, 2024, 85, 91.00, 21.50, 7200.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (20, 4, 2025, 88, 92.20, 22.80, 7500.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (21, 5, 2021, 55, 82.50, 25.00, 5600.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (22, 5, 2022, 58, 84.20, 26.80, 5900.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (23, 5, 2023, 60, 86.00, 28.50, 6200.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (24, 5, 2024, 62, 87.80, 30.00, 6500.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (25, 5, 2025, 65, 89.50, 31.50, 6800.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (26, 6, 2021, 35, 70.20, 10.50, 5000.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (27, 6, 2022, 38, 72.80, 11.20, 5300.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (28, 6, 2023, 40, 75.00, 12.00, 5500.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (29, 6, 2024, 42, 76.50, 12.80, 5700.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (30, 6, 2025, 45, 78.20, 13.50, 5900.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (31, 7, 2021, 72, 87.50, 22.50, 7000.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (32, 7, 2022, 75, 89.20, 24.00, 7300.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (33, 7, 2023, 78, 90.50, 25.50, 7600.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (34, 7, 2024, 80, 92.00, 27.00, 7900.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (35, 7, 2025, 85, 93.50, 28.50, 8200.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (36, 8, 2021, 45, 80.50, 12.50, 5500.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (37, 8, 2022, 48, 82.00, 13.20, 5800.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (38, 8, 2023, 50, 83.50, 13.80, 6000.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (39, 8, 2024, 52, 85.00, 14.50, 6200.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `graduate_outcome` VALUES (40, 8, 2025, 55, 86.50, 15.00, 6500.00, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '导入任务表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '指标规则表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of indicator_rule
-- ----------------------------
INSERT INTO `indicator_rule` VALUES (1, 'PHD_RATE', '博士占比', 20.00, 'LT', 40.00, 1, '低于40%触发预警', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `indicator_rule` VALUES (2, 'ADMISSION_COMPLETION_RATE', '招生完成率', 20.00, 'LT', 90.00, 1, '低于90%触发预警', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `indicator_rule` VALUES (3, 'FUNDING_UTILIZATION_RATE', '经费使用率', 20.00, 'LT', 70.00, 1, '低于70%触发预警', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `indicator_rule` VALUES (4, 'EMPLOYMENT_RATE', '就业率', 20.00, 'LT', 80.00, 1, '低于80%触发预警', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `indicator_rule` VALUES (5, 'POSTGRADUATE_RATE', '升学率', 20.00, 'LT', 15.00, 1, '低于15%触发预警', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '国际交流表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of international_exchange
-- ----------------------------
INSERT INTO `international_exchange` VALUES (1, 2, '护理国际交流项目', 2023, '完成海外临床见习', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `international_exchange` VALUES (2, 19, '检验技术交流访问', 2024, '发表交流报告', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `international_exchange` VALUES (3, 39, '公共卫生国际研讨', 2024, '联合流行病学研究', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `international_exchange` VALUES (4, 57, '药学学术交流', 2025, '参与国际药物研发合作', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生国际交流信息表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '专业信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of major
-- ----------------------------
INSERT INTO `major` VALUES (1, 1, '护理学', 'MAJ001', '本科', '医学', 4, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `major` VALUES (2, 1, '助产学', 'MAJ002', '本科', '医学', 4, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `major` VALUES (3, 2, '医学检验技术', 'MAJ003', '本科', '医学技术', 4, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `major` VALUES (4, 2, '医学影像技术', 'MAJ004', '本科', '医学技术', 4, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `major` VALUES (5, 3, '预防医学', 'MAJ005', '本科', '公共卫生', 5, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `major` VALUES (6, 3, '卫生检验与检疫', 'MAJ006', '本科', '公共卫生', 4, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `major` VALUES (7, 4, '药学', 'MAJ007', '本科', '药学', 4, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `major` VALUES (8, 4, '中药学', 'MAJ008', '本科', '中药学', 4, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of operation_log
-- ----------------------------
INSERT INTO `operation_log` VALUES (1, 1, 'admin', '用户管理', '新增用户', 'POST', '/api/users', '{\"username\":\"hlxy\",\"realName\":\"护理学院\",\"phone\":\"13938549908\",\"email\":\"12345@163.com\",\"roleCode\":\"DEPT_ADMIN\",\"scopeType\":\"DEPT\",\"scopeId\":1,\"status\":1}', 0, 'rawPassword cannot be null', '2026-03-20 11:34:40', 0);
INSERT INTO `operation_log` VALUES (2, 1, 'admin', '用户管理', '新增用户', 'POST', '/api/users', '{\"username\":\"hlxy\",\"realName\":\"护理学院\",\"phone\":\"13938549908\",\"email\":\"12345@163.com\",\"roleCode\":\"DEPT_ADMIN\",\"scopeType\":\"DEPT\",\"scopeId\":1,\"status\":1}', 0, 'rawPassword cannot be null', '2026-03-20 11:34:46', 0);
INSERT INTO `operation_log` VALUES (3, 1, 'admin', '用户管理', '新增用户', 'POST', '/api/users', '{\"username\":\"hlxy\",\"realName\":\"护理学院\",\"phone\":\"13938549908\",\"email\":\"12345@163.com\",\"roleCode\":\"DEPT_ADMIN\",\"scopeType\":\"DEPT\",\"scopeId\":1,\"status\":1}', 0, 'rawPassword cannot be null', '2026-03-20 11:35:05', 0);
INSERT INTO `operation_log` VALUES (4, 1, 'admin', '用户管理', '新增用户', 'POST', '/api/users', '{\"username\":\"hlxy\",\"realName\":\"护理学院\",\"phone\":\"13938549908\",\"email\":\"12345@163.com\",\"roleCode\":\"DEPT_ADMIN\",\"scopeType\":\"DEPT\",\"scopeId\":1,\"status\":1}', 0, 'rawPassword cannot be null', '2026-03-20 11:35:16', 0);
INSERT INTO `operation_log` VALUES (5, 1, 'admin', '用户管理', '新增用户', 'POST', '/api/users', '{\"username\":\"hlxy\",\"realName\":\"护理学院\",\"phone\":\"13938549908\",\"email\":\"12345@163.com\",\"roleCode\":\"DEPT_ADMIN\",\"scopeType\":\"DEPT\",\"scopeId\":1,\"status\":1}', 1, NULL, '2026-03-20 11:37:29', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '报表模板表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of report_template
-- ----------------------------
INSERT INTO `report_template` VALUES (1, '专业年度总览', '用于导出专业年度指标汇总', 'EXCEL', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `report_template` VALUES (2, '预警清单', '用于导出当前预警记录', 'EXCEL', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '报表模板表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '教师科研成果表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学校信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of school
-- ----------------------------
INSERT INTO `school` VALUES (1, '示例医科大学', 'SCH001', '本科', '公办', '省属重点', 'https://www.example.edu.cn', '张老师', '13800000001', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 75 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学生信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (1, 1, 'S001', '刘洋', 'M', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (2, 1, 'S002', '孙悦', 'F', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (3, 1, 'S003', '赵琳', 'F', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (4, 1, 'S004', '钱丽', 'F', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (5, 1, 'S005', '周华', 'M', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (6, 1, 'S006', '郑宇', 'F', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (7, 1, 'S007', '王亮', 'M', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (8, 1, 'S008', '韩月', 'F', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (9, 1, 'S009', '冯珊', 'F', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (10, 1, 'S010', '陈阳', 'M', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (11, 2, 'S011', '杨静', 'F', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (12, 2, 'S012', '吴彤', 'F', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (13, 2, 'S013', '许薇', 'F', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (14, 2, 'S014', '朱莉', 'F', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (15, 2, 'S015', '马萍', 'F', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (16, 2, 'S016', '黄颖', 'F', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (17, 2, 'S017', '林婷', 'F', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (18, 2, 'S018', '何敏', 'F', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (19, 3, 'S019', '高翔', 'M', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (20, 3, 'S020', '程琳', 'F', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (21, 3, 'S021', '罗浩', 'M', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (22, 3, 'S022', '沈薇', 'F', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (23, 3, 'S023', '方杰', 'M', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (24, 3, 'S024', '田甜', 'F', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (25, 3, 'S025', '任磊', 'M', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (26, 3, 'S026', '姜丹', 'F', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (27, 3, 'S027', '潘悦', 'F', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (28, 3, 'S028', '崔明', 'M', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (29, 4, 'S029', '丁磊', 'M', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (30, 4, 'S030', '谢芳', 'F', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (31, 4, 'S031', '苏军', 'M', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (32, 4, 'S032', '卢佳', 'F', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (33, 4, 'S033', '邵鹏', 'M', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (34, 4, 'S034', '薛莹', 'F', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (35, 4, 'S035', '叶凯', 'M', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (36, 4, 'S036', '廖颖', 'F', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (37, 4, 'S037', '范洋', 'M', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (38, 4, 'S038', '秦丽', 'F', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (39, 5, 'S039', '余波', 'M', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (40, 5, 'S040', '魏琳', 'F', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (41, 5, 'S041', '蒋杰', 'M', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (42, 5, 'S042', '邹丽', 'F', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (43, 5, 'S043', '石磊', 'M', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (44, 5, 'S044', '童颖', 'F', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (45, 5, 'S045', '贺鑫', 'M', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (46, 5, 'S046', '梁婷', 'F', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (47, 5, 'S047', '顾明', 'M', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (48, 5, 'S048', '孟雪', 'F', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (49, 6, 'S049', '龙辉', 'M', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (50, 6, 'S050', '白梅', 'F', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (51, 6, 'S051', '侯强', 'M', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (52, 6, 'S052', '傅敏', 'F', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (53, 6, 'S053', '雷鑫', 'M', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (54, 6, 'S054', '贾莉', 'F', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (55, 6, 'S055', '尹浩', 'M', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (56, 6, 'S056', '夏琳', 'F', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (57, 7, 'S057', '段勇', 'M', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (58, 7, 'S058', '曾薇', 'F', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (59, 7, 'S059', '武刚', 'M', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (60, 7, 'S060', '康婷', 'F', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (61, 7, 'S061', '严杰', 'M', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (62, 7, 'S062', '姚丽', 'F', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (63, 7, 'S063', '谭鹏', 'M', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (64, 7, 'S064', '戴颖', 'F', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (65, 7, 'S065', '邱明', 'M', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (66, 7, 'S066', '熊佳', 'F', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (67, 8, 'S067', '金波', 'M', 2021, '毕业', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (68, 8, 'S068', '毛芳', 'F', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (69, 8, 'S069', '万军', 'M', 2022, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (70, 8, 'S070', '龚颖', 'F', 2023, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (71, 8, 'S071', '钟磊', 'M', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (72, 8, 'S072', '阮丽', 'F', 2024, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (73, 8, 'S073', '邢鑫', 'M', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `student` VALUES (74, 8, 'S074', '柳雪', 'F', 2025, '在校', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '{bcrypt}$2a$10$aX9pFSMWNvBKq1e2gxfc2ODqSN9AsuxhGUzDWyWawjBvCwShpjiTa', '系统管理员', NULL, NULL, 'SCHOOL_ADMIN', 'SCHOOL', 1, 1, '2026-05-02 17:07:25', '2026-03-11 17:47:22', '2026-03-11 17:47:22', 0);
INSERT INTO `sys_user` VALUES (2, 'hlxy', '{bcrypt}$2a$10$aX9pFSMWNvBKq1e2gxfc2ODqSN9AsuxhGUzDWyWawjBvCwShpjiTa', '护理学院', '13938549908', '12345@163.com', 'DEPT_ADMIN', 'DEPT', 1, 1, '2026-05-02 15:11:01', '2026-03-20 11:37:30', '2026-04-13 22:06:18', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '教师信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES (1, 1, 'T001', '王芳', '教授', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (2, 1, 'T002', '李敏', '副教授', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (3, 1, 'T003', '周洁', '讲师', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (4, 1, 'T004', '张慧', '副教授', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (5, 1, 'T005', '陈雪', '讲师', '硕士', 0, '兼职', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (6, 1, 'T006', '刘丽', '教授', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (7, 1, 'T007', '孙梅', '讲师', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (8, 1, 'T008', '杨红', '助教', '学士', 0, '兼职', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (9, 2, 'T009', '陈涛', '教授', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (10, 2, 'T010', '赵蕾', '副教授', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (11, 2, 'T011', '黄伟', '讲师', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (12, 2, 'T012', '吴婷', '副教授', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (13, 2, 'T013', '林峰', '教授', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (14, 2, 'T014', '徐静', '讲师', '硕士', 0, '兼职', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (15, 2, 'T015', '何强', '副教授', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (16, 2, 'T016', '郑敏', '讲师', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (17, 2, 'T017', '曹磊', '助教', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (18, 2, 'T018', '冯雪', '助教', '学士', 0, '兼职', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (19, 3, 'T019', '谢明', '教授', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (20, 3, 'T020', '韩冰', '副教授', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (21, 3, 'T021', '唐飞', '教授', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (22, 3, 'T022', '邓丽', '副教授', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (23, 3, 'T023', '宋刚', '讲师', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (24, 3, 'T024', '彭颖', '讲师', '硕士', 0, '兼职', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (25, 3, 'T025', '罗辉', '副教授', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (26, 3, 'T026', '蔡琳', '讲师', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (27, 3, 'T027', '马强', '助教', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (28, 4, 'T028', '朱军', '教授', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (29, 4, 'T029', '高燕', '副教授', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (30, 4, 'T030', '田华', '讲师', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (31, 4, 'T031', '丁勇', '副教授', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (32, 4, 'T032', '许佳', '教授', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (33, 4, 'T033', '卢萍', '讲师', '硕士', 0, '兼职', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (34, 4, 'T034', '叶辉', '副教授', '博士', 1, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (35, 4, 'T035', '范磊', '讲师', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (36, 4, 'T036', '方洁', '助教', '硕士', 0, '专任', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `teacher` VALUES (37, 4, 'T037', '秦鑫', '助教', '学士', 0, '兼职', '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 62 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预警记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of warning_record
-- ----------------------------
INSERT INTO `warning_record` VALUES (1, 1, 'PHD_RATE', '博士占比', 2023, 'LT', 40.00, 37.50, 'ACTIVE', '博士占比 actual 37.50 threshold 40.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (2, 2, 'PHD_RATE', '博士占比', 2023, 'LT', 40.00, 37.50, 'ACTIVE', '博士占比 actual 37.50 threshold 40.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (3, 2, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2023, 'LT', 90.00, 83.08, 'ACTIVE', '招生完成率 actual 83.08 threshold 90.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (4, 2, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2023, 'LT', 70.00, 61.67, 'ACTIVE', '经费使用率 actual 61.67 threshold 70.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (5, 2, 'EMPLOYMENT_RATE', '就业率', 2023, 'LT', 80.00, 76.20, 'ACTIVE', '就业率 actual 76.20 threshold 80.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (6, 2, 'POSTGRADUATE_RATE', '升学率', 2023, 'LT', 15.00, 10.80, 'ACTIVE', '升学率 actual 10.80 threshold 15.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (7, 6, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2023, 'LT', 90.00, 83.64, 'ACTIVE', '招生完成率 actual 83.64 threshold 90.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (8, 6, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2023, 'LT', 70.00, 63.00, 'ACTIVE', '经费使用率 actual 63.00 threshold 70.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (9, 6, 'EMPLOYMENT_RATE', '就业率', 2023, 'LT', 80.00, 75.00, 'ACTIVE', '就业率 actual 75.00 threshold 80.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (10, 6, 'POSTGRADUATE_RATE', '升学率', 2023, 'LT', 15.00, 12.00, 'ACTIVE', '升学率 actual 12.00 threshold 15.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (11, 8, 'POSTGRADUATE_RATE', '升学率', 2023, 'LT', 15.00, 13.80, 'ACTIVE', '升学率 actual 13.80 threshold 15.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (12, 1, 'PHD_RATE', '博士占比', 2024, 'LT', 40.00, 37.50, 'ACTIVE', '博士占比 actual 37.50 threshold 40.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (13, 2, 'PHD_RATE', '博士占比', 2024, 'LT', 40.00, 37.50, 'ACTIVE', '博士占比 actual 37.50 threshold 40.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (14, 2, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2024, 'LT', 90.00, 85.71, 'ACTIVE', '招生完成率 actual 85.71 threshold 90.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (15, 2, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2024, 'LT', 70.00, 64.62, 'ACTIVE', '经费使用率 actual 64.62 threshold 70.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (16, 2, 'EMPLOYMENT_RATE', '就业率', 2024, 'LT', 80.00, 78.50, 'ACTIVE', '就业率 actual 78.50 threshold 80.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (17, 2, 'POSTGRADUATE_RATE', '升学率', 2024, 'LT', 15.00, 11.50, 'ACTIVE', '升学率 actual 11.50 threshold 15.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (18, 6, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2024, 'LT', 90.00, 86.21, 'ACTIVE', '招生完成率 actual 86.21 threshold 90.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (19, 6, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2024, 'LT', 70.00, 66.67, 'ACTIVE', '经费使用率 actual 66.67 threshold 70.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (20, 6, 'EMPLOYMENT_RATE', '就业率', 2024, 'LT', 80.00, 76.50, 'ACTIVE', '就业率 actual 76.50 threshold 80.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (21, 6, 'POSTGRADUATE_RATE', '升学率', 2024, 'LT', 15.00, 12.80, 'ACTIVE', '升学率 actual 12.80 threshold 15.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (22, 8, 'POSTGRADUATE_RATE', '升学率', 2024, 'LT', 15.00, 14.50, 'ACTIVE', '升学率 actual 14.50 threshold 15.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (23, 1, 'PHD_RATE', '博士占比', 2025, 'LT', 40.00, 37.50, 'ACTIVE', '博士占比 actual 37.50 threshold 40.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (24, 2, 'PHD_RATE', '博士占比', 2025, 'LT', 40.00, 37.50, 'ACTIVE', '博士占比 actual 37.50 threshold 40.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (25, 2, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2025, 'LT', 90.00, 86.67, 'ACTIVE', '招生完成率 actual 86.67 threshold 90.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (26, 2, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2025, 'LT', 70.00, 67.14, 'ACTIVE', '经费使用率 actual 67.14 threshold 70.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (27, 2, 'EMPLOYMENT_RATE', '就业率', 2025, 'LT', 80.00, 79.80, 'ACTIVE', '就业率 actual 79.80 threshold 80.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (28, 2, 'POSTGRADUATE_RATE', '升学率', 2025, 'LT', 15.00, 12.20, 'ACTIVE', '升学率 actual 12.20 threshold 15.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (29, 6, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2025, 'LT', 90.00, 86.67, 'ACTIVE', '招生完成率 actual 86.67 threshold 90.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (30, 6, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2025, 'LT', 70.00, 67.83, 'ACTIVE', '经费使用率 actual 67.83 threshold 70.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (31, 6, 'EMPLOYMENT_RATE', '就业率', 2025, 'LT', 80.00, 78.20, 'ACTIVE', '就业率 actual 78.20 threshold 80.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (32, 6, 'POSTGRADUATE_RATE', '升学率', 2025, 'LT', 15.00, 13.50, 'ACTIVE', '升学率 actual 13.50 threshold 15.00', '2026-03-20 10:22:23', NULL, '2026-03-20 10:22:23', '2026-03-20 10:22:23', 0);
INSERT INTO `warning_record` VALUES (33, 1, 'PHD_RATE', '博士占比', 2021, 'LT', 40.00, 37.50, 'ACTIVE', '博士占比 actual 37.50 threshold 40.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (34, 1, 'PHD_RATE', '博士占比', 2022, 'LT', 40.00, 37.50, 'ACTIVE', '博士占比 actual 37.50 threshold 40.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (35, 2, 'PHD_RATE', '博士占比', 2021, 'LT', 40.00, 37.50, 'ACTIVE', '博士占比 actual 37.50 threshold 40.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (36, 2, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2021, 'LT', 90.00, 76.36, 'ACTIVE', '招生完成率 actual 76.36 threshold 90.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (37, 2, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2021, 'LT', 70.00, 55.00, 'ACTIVE', '经费使用率 actual 55.00 threshold 70.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (38, 2, 'EMPLOYMENT_RATE', '就业率', 2021, 'LT', 80.00, 72.50, 'ACTIVE', '就业率 actual 72.50 threshold 80.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (39, 2, 'POSTGRADUATE_RATE', '升学率', 2021, 'LT', 15.00, 8.20, 'ACTIVE', '升学率 actual 8.20 threshold 15.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (40, 2, 'PHD_RATE', '博士占比', 2022, 'LT', 40.00, 37.50, 'ACTIVE', '博士占比 actual 37.50 threshold 40.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (41, 2, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2022, 'LT', 90.00, 80.00, 'ACTIVE', '招生完成率 actual 80.00 threshold 90.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (42, 2, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2022, 'LT', 70.00, 58.18, 'ACTIVE', '经费使用率 actual 58.18 threshold 70.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (43, 2, 'EMPLOYMENT_RATE', '就业率', 2022, 'LT', 80.00, 74.80, 'ACTIVE', '就业率 actual 74.80 threshold 80.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (44, 2, 'POSTGRADUATE_RATE', '升学率', 2022, 'LT', 15.00, 9.50, 'ACTIVE', '升学率 actual 9.50 threshold 15.00', '2026-04-13 22:02:09', NULL, '2026-04-13 22:02:09', '2026-04-13 22:02:09', 0);
INSERT INTO `warning_record` VALUES (45, 4, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2021, 'LT', 90.00, 88.89, 'ACTIVE', '招生完成率 actual 88.89 threshold 90.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (46, 5, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2021, 'LT', 90.00, 85.71, 'ACTIVE', '招生完成率 actual 85.71 threshold 90.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (47, 5, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2022, 'LT', 90.00, 88.89, 'ACTIVE', '招生完成率 actual 88.89 threshold 90.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (48, 6, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2021, 'LT', 90.00, 76.00, 'ACTIVE', '招生完成率 actual 76.00 threshold 90.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (49, 6, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2021, 'LT', 70.00, 53.33, 'ACTIVE', '经费使用率 actual 53.33 threshold 70.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (50, 6, 'EMPLOYMENT_RATE', '就业率', 2021, 'LT', 80.00, 70.20, 'ACTIVE', '就业率 actual 70.20 threshold 80.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (51, 6, 'POSTGRADUATE_RATE', '升学率', 2021, 'LT', 15.00, 10.50, 'ACTIVE', '升学率 actual 10.50 threshold 15.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (52, 6, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2022, 'LT', 90.00, 80.77, 'ACTIVE', '招生完成率 actual 80.77 threshold 90.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (53, 6, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2022, 'LT', 70.00, 57.89, 'ACTIVE', '经费使用率 actual 57.89 threshold 70.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (54, 6, 'EMPLOYMENT_RATE', '就业率', 2022, 'LT', 80.00, 72.80, 'ACTIVE', '就业率 actual 72.80 threshold 80.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (55, 6, 'POSTGRADUATE_RATE', '升学率', 2022, 'LT', 15.00, 11.20, 'ACTIVE', '升学率 actual 11.20 threshold 15.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (56, 8, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2021, 'LT', 90.00, 83.33, 'ACTIVE', '招生完成率 actual 83.33 threshold 90.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (57, 8, 'FUNDING_UTILIZATION_RATE', '经费使用率', 2021, 'LT', 70.00, 67.69, 'ACTIVE', '经费使用率 actual 67.69 threshold 70.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (58, 8, 'POSTGRADUATE_RATE', '升学率', 2021, 'LT', 15.00, 12.50, 'ACTIVE', '升学率 actual 12.50 threshold 15.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (59, 8, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2022, 'LT', 90.00, 85.48, 'ACTIVE', '招生完成率 actual 85.48 threshold 90.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (60, 8, 'POSTGRADUATE_RATE', '升学率', 2022, 'LT', 15.00, 13.20, 'ACTIVE', '升学率 actual 13.20 threshold 15.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);
INSERT INTO `warning_record` VALUES (61, 8, 'ADMISSION_COMPLETION_RATE', '招生完成率', 2023, 'LT', 90.00, 89.23, 'ACTIVE', '招生完成率 actual 89.23 threshold 90.00', '2026-04-13 22:02:10', NULL, '2026-04-13 22:02:10', '2026-04-13 22:02:10', 0);

SET FOREIGN_KEY_CHECKS = 1;
