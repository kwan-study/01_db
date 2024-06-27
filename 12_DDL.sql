/* DDL(Data Definition Language) */
CREATE TABLE if NOT EXISTS tb1 (
  pk INT PRIMARY KEY, -- 컬럼 레벨의 제약조건
  fk INT,
  col1 VARCHAR(255),
  CHECK(col1 IN ('Y', 'N')) -- 테이블 레벨의 제약조건
) ENGINE = INNODB;

-- 존재하는 테이블을 요약해서 보고 싶을 때..
DESC tb1;
DESCRIBE tb1;

INSERT
  INTO tb1
VALUES
(
  1, 2, 'Y'
);

/* auto_increment */
DROP TABLE tb2;

CREATE TABLE tb2 (
  pk INT PRIMARY KEY AUTO_INCREMENT,
  fk INT,
  col1 VARCHAR(255),
  CHECK(col1 IN ('Y', 'N'))
) ENGINE = INNODB;

DESC tb1;

INSERT
  INTO tb2
VALUES
(
  NULL
, 2
, 'N'
);


/* alter */
-- 컬럼 추가
ALTER TABLE tb2 ADD col2 INT NOT NULL;

DESC tb2;

-- 컬럼 삭제
ALTER TABLE tb2 DROP COLUMN col2;

-- 컬럼 이름 및 컬럼 정의 변경
ALTER TABLE tb2 CHANGE COLUMN fk change_fk INT NOT NULL;
DESC tb2;

-- 제약조건 제거(primary key 제약조건 제거 도전)
ALTER TABLE tb2 DROP PRIMARY KEY; -- -> 불가

-- auto_increment 먼저 제거(drop이 아닌 modify)
ALTER TABLE tb2 MODIFY pk INT;
DESC tb2;

-- 다시 primary key 제거
ALTER TABLE tb2 DROP PRIMARY KEY;
DESC tb2;

/* truncate(관련 데이터 남김없이 절삭) */
/*CREATE TABLE if NOT EXISTS tb3 (
  pk INT AUTO_INCREMENT,
  fk INT,
  col1 VARCHAR(255) CHECK(col1 IN ('Y', 'N')),
  PRIMARY KEY(pk)
);

DESC tb3;

TRUNCATE table tb3;
*/


