DROP TABLE IF EXISTS warning_record;
DROP TABLE IF EXISTS operation_log;
DROP TABLE IF EXISTS import_task;
DROP TABLE IF EXISTS report_template;
DROP TABLE IF EXISTS indicator_rule;
DROP TABLE IF EXISTS achievement;
DROP TABLE IF EXISTS graduate_outcome;
DROP TABLE IF EXISTS international_exchange;
DROP TABLE IF EXISTS competition;
DROP TABLE IF EXISTS funding;
DROP TABLE IF EXISTS admission;
DROP TABLE IF EXISTS experiment_base;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS sys_user;
DROP TABLE IF EXISTS major;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS campus;
DROP TABLE IF EXISTS school;

CREATE TABLE school (
  school_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(50) NOT NULL,
  type VARCHAR(50),
  nature VARCHAR(50),
  level VARCHAR(50),
  website VARCHAR(255),
  contact_name VARCHAR(100),
  contact_phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_school_code UNIQUE (code)
);

CREATE TABLE campus (
  campus_id INT PRIMARY KEY AUTO_INCREMENT,
  school_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  province VARCHAR(50),
  city VARCHAR(50),
  district VARCHAR(50),
  is_main TINYINT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0
);

CREATE TABLE department (
  dept_id INT PRIMARY KEY AUTO_INCREMENT,
  school_id INT NOT NULL,
  code VARCHAR(50) NOT NULL,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_department_code UNIQUE (code)
);

CREATE TABLE major (
  major_id INT PRIMARY KEY AUTO_INCREMENT,
  dept_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(50) NOT NULL,
  level VARCHAR(50),
  category VARCHAR(50),
  duration_years INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_major_code UNIQUE (code)
);

CREATE TABLE sys_user (
  user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(64) NOT NULL,
  password VARCHAR(255) NOT NULL,
  real_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100),
  role_code VARCHAR(32) NOT NULL,
  scope_type VARCHAR(32) NOT NULL,
  scope_id BIGINT NOT NULL,
  status TINYINT DEFAULT 1,
  last_login_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_sys_user_username UNIQUE (username)
);

CREATE TABLE teacher (
  teacher_id INT PRIMARY KEY AUTO_INCREMENT,
  dept_id INT NOT NULL,
  teacher_no VARCHAR(50) NOT NULL,
  name VARCHAR(100) NOT NULL,
  title VARCHAR(50),
  degree VARCHAR(50),
  phd_flag TINYINT DEFAULT 0,
  employment_type VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_teacher_no UNIQUE (teacher_no)
);

CREATE TABLE student (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  major_id INT NOT NULL,
  student_no VARCHAR(50) NOT NULL,
  name VARCHAR(100) NOT NULL,
  gender CHAR(1),
  enrollment_year INT,
  status VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_student_no UNIQUE (student_no)
);

CREATE TABLE course (
  course_id INT PRIMARY KEY AUTO_INCREMENT,
  major_id INT NOT NULL,
  course_code VARCHAR(50) NOT NULL,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50),
  credits DECIMAL(4,1),
  semester VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_course_code UNIQUE (course_code)
);

CREATE TABLE experiment_base (
  base_id INT PRIMARY KEY AUTO_INCREMENT,
  major_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50),
  location VARCHAR(255),
  capacity INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0
);

CREATE TABLE admission (
  admission_id INT PRIMARY KEY AUTO_INCREMENT,
  major_id INT NOT NULL,
  stat_year INT NOT NULL,
  plan_count INT,
  actual_count INT,
  min_score DECIMAL(5,2),
  max_score DECIMAL(5,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_admission_major_year UNIQUE (major_id, stat_year)
);

CREATE TABLE funding (
  funding_id INT PRIMARY KEY AUTO_INCREMENT,
  major_id INT NOT NULL,
  stat_year INT NOT NULL,
  allocated DECIMAL(12,2),
  spent DECIMAL(12,2),
  utilization_rate DECIMAL(5,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_funding_major_year UNIQUE (major_id, stat_year)
);

CREATE TABLE competition (
  competition_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  level VARCHAR(50),
  award VARCHAR(255),
  stat_year INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0
);

CREATE TABLE international_exchange (
  exchange_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  program VARCHAR(255) NOT NULL,
  stat_year INT,
  outcome VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0
);

CREATE TABLE graduate_outcome (
  outcome_id INT PRIMARY KEY AUTO_INCREMENT,
  major_id INT NOT NULL,
  stat_year INT NOT NULL,
  graduate_count INT DEFAULT 0,
  employment_rate DECIMAL(5,2),
  postgraduate_rate DECIMAL(5,2),
  average_salary DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_graduate_outcome_major_year UNIQUE (major_id, stat_year)
);

CREATE TABLE achievement (
  achievement_id INT PRIMARY KEY AUTO_INCREMENT,
  teacher_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50),
  stat_year INT,
  unit_count INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0
);

CREATE TABLE indicator_rule (
  rule_id INT PRIMARY KEY AUTO_INCREMENT,
  indicator_code VARCHAR(64) NOT NULL,
  indicator_name VARCHAR(128) NOT NULL,
  weight DECIMAL(5,2) DEFAULT 0,
  compare_type VARCHAR(8) NOT NULL,
  threshold_value DECIMAL(10,2) NOT NULL,
  enabled TINYINT DEFAULT 1,
  remark VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_indicator_rule_code UNIQUE (indicator_code)
);

CREATE TABLE warning_record (
  warning_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  major_id INT NOT NULL,
  indicator_code VARCHAR(64) NOT NULL,
  indicator_name VARCHAR(128) NOT NULL,
  stat_year INT NOT NULL,
  compare_type VARCHAR(8) NOT NULL,
  threshold_value DECIMAL(10,2) NOT NULL,
  actual_value DECIMAL(10,2) NOT NULL,
  status VARCHAR(16) DEFAULT 'ACTIVE',
  message VARCHAR(255),
  triggered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  cleared_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0
);

CREATE TABLE report_template (
  template_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(500),
  format VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0,
  CONSTRAINT uk_report_template_name UNIQUE (name)
);

CREATE TABLE import_task (
  task_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  task_type VARCHAR(64) NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  status VARCHAR(16) NOT NULL,
  total_rows INT DEFAULT 0,
  success_rows INT DEFAULT 0,
  fail_rows INT DEFAULT 0,
  error_message VARCHAR(1000),
  operator_user_id BIGINT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0
);

CREATE TABLE operation_log (
  log_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT,
  username VARCHAR(64),
  module VARCHAR(64),
  operation VARCHAR(64),
  request_method VARCHAR(16),
  request_uri VARCHAR(255),
  request_body VARCHAR(2000),
  success TINYINT DEFAULT 1,
  error_message VARCHAR(1000),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted TINYINT DEFAULT 0
);
