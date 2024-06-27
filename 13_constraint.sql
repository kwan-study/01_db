/* constraint */
/* 1. not null 제약 조건 */
-- null 값을 포함할 수 없는 컬럼에 대한 제약조건이자 컬럼 레벨에서만 제약조건 추가 가능
DROP TABLE if EXISTS user_notnull;
CREATE TABLE if NOT EXISTS user_notnull (
  user_no INT NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  user_pwd VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3),
  phone VARCHAR(255) NOT NULL,
  email VARCHAR(255)
) ENGINE=INNODB;

INSERT
  INTO user_notnull
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-7777-7777', 'yu77@gmail.com');

INSERT
  INTO user_notnull
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, 'user01', 'pass01', null, '남', '010-1234-5678', 'hong123@gmail.com'); -- not null constraint 위반

/* 2. unique 제약 조건 */
-- 중복값이 들어가지 않도록 하는 제약 조건이다.
-- column level 및 table level 모두 가능하다.
CREATE TABLE if NOT EXISTS user_unique (
  user_no INT NOT NULL UNIQUE,
  user_id VARCHAR(255) NOT NULL,
  user_pwd VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3),
  phone VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  UNIQUE(phone)
) ENGINE=INNODB;

INSERT
  INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-7777-7777', 'yu77@gmail.com');

INSERT
  INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, 'user03', 'pass03', '홍길동3', '남', '010-1234-5678', 'hong1234@gmail.com'); -- unique 위반

/* 3. primary key 제약조건 */
-- not null + unique 제약조건이라고 볼 수 있다.
-- 모든 테이블은 반드시 primary key를 하나 가져야 한다.(두 개 이상 제약조건을 할 수는 없다.)
CREATE TABLE if NOT EXISTS user_primarykey (
  user_no INT /*PRIMARY KEY*/,
  user_id VARCHAR(255) NOT NULL,
  user_pwd VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3),
  phone VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  UNIQUE(phone),
  PRIMARY KEY(user_no)
) ENGINE=INNODB;

INSERT
  INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-7777-7777', 'yu77@gmail.com');

INSERT
  INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'); -- primary key 위반

/* 4. foreign key 제약조건 */
-- 4-1. 회원 등급 부모 테이블
DROP TABLE if EXISTS user_grade;
CREATE TABLE if NOT EXISTS user_grade (
  grade_code INT PRIMARY KEY,
  grade_name VARCHAR(255) NOT NULL
);

-- 4-2. 자식 테이블을 이후에 생성
CREATE TABLE if NOT EXISTS user_foreignkey1 (
  user_no INT PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  user_pwd VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3),
  phone VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  grade_code INT,
  FOREIGN KEY(grade_code) REFERENCES user_grade(grade_code)
) ENGINE=INNODB;

-- cardinality를 따져서 부모 자식 결정해라!!!
-- 부모 테이블에 먼저 값이 들어가 있어야 자식이 참조 가능.
INSERT
  INTO user_grade
VALUES
(10, '일반회원'),
(20, '우수회원'),
(30, '특별회원');

-- 연관 관계의 주인은 자식. fk에 null을 넣으면 관계가 끊어지기 때문.
INSERT
  INTO user_foreignkey1
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1111-1111', 'hong@gmail.com', 10),
(2, 'user02', 'pass02', '유관순', '여', '010-2222-2222', 'yu@gmail.com', 20);

-- fk 제약조건이 걸린 컬럼은 부모테이블의 pk값 + null값까지 들어갈 수 있다. 
INSERT
  INTO user_foreignkey1
VALUES
(3, 'user01', 'pass01', '홍길동', '남', '010-1111-1111', 'hong@gmail.com', NULL);

INSERT
  INTO user_foreignkey1
VALUES
(4, 'user02', 'pass02', '유관순', '여', '010-2222-2222', 'yu@gmail.com', 40); -- fk 제약조건 위반

DELETE
  FROM user_grade
 WHERE grade_code = 10; -- 자식이 참조 중이므로 삭제 불가
 
DELETE
  FROM user_grade
 WHERE grade_code = 30; -- 참조하고 있지 않으므로 삭제 가능

-- 4-3. 삭제룰을 적용한 foreign key 제약조건 작성
CREATE TABLE if NOT EXISTS user_foreignkey2 (
  user_no INT PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  user_pwd VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3),
  phone VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  grade_code INT,
  FOREIGN KEY(grade_code) REFERENCES user_grade(grade_code)
  ON DELETE SET NULL
) ENGINE=INNODB;

INSERT
  INTO user_foreignkey2
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1111-1111', 'hong@gmail.com', 10);

TRUNCATE user_foreignkey1; -- 다른 자식테이블이 참조 중이므로 데이터 방해를 먼저 제거하고 실험

SELECT * FROM user_foreignkey2; -- 현재 회원의 참조 컬럼 값 확인

-- 참조하는 부모 테이블의 행 삭제 후 참조 컬럼 값 확인
DELETE
  FROM user_grade
 WHERE grade_code = 10;
SELECT * FROM user_foreignkey2;


CREATE TABLE if NOT EXISTS user_foreignkey3 (
  user_no INT PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  user_pwd VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3),
  phone VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  grade_code INT REFERENCES user_grade(grade_code)
  ON DELETE SET NULL
) ENGINE=INNODB;

DESC user_foreignkey3;
DESC user_foreignkey2;


/* default 제약조건 */
-- 컬럼에 값을 삽입하지 않았을 때, 기본적으로 들어가는 값을 제약조건을 걸어둔다.
CREATE TABLE if NOT EXISTS tbl_country (
  country_code INT AUTO_INCREMENT PRIMARY KEY,
  country_name VARCHAR(255) DEFAULT '한국',
  population VARCHAR(255) DEFAULT '0명',
  add_day DATE DEFAULT (CURRENT_DATE),
  add_time DATETIME DEFAULT (CURRENT_TIME)
) ENGINE=INNODB;

INSERT
  INTO tbl_country
VALUES
(NULL, DEFAULT, DEFAULT, DEFAULT, DEFAULT);

SELECT * FROM tbl_country;