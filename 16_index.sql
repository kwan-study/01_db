/* index */
SELECT * FROM tbl_menu; -- -> 모든 컬럼을 다 순회함.
-- 모든 테이블의 pk column은 index가 자동으로 부여됨

CREATE TABLE phone (
  phone_code INT PRIMARY KEY,
  phone_name VARCHAR(100),
  phone_price DECIMAL(10, 2)
);

INSERT
  INTO phone
VALUES
(1, 'galaxyS24', 1200000),
(2, 'iphone14pro', 1430000),
(3, 'galaxyfold3', 1730000);

SELECT * FROM phone;

-- where 절을 활용한 단순 조회
SELECT * FROM phone WHERE phone_name = 'galaxyS24';
EXPLAIN SELECT * FROM phone WHERE phone_name = 'galaxyS24';

-- phone_name 에 index 추가
CREATE INDEX idx_name ON phone(phone_name);
SHOW INDEX FROM phone;

-- 다시 index가 추가된 컬럼으로 조회해서 index를 태웠는지 확인
SELECT * FROM phone WHERE phone_name = 'galaxyS24';
EXPLAIN SELECT * FROM phone WHERE phone_name = 'galaxyS24';

-- 고유 index를 제외하고 추가적으로 등록한 index가 있다면 주기적으로 rebuild 해줘야  함.
-- MariaDB에서는 optimize 키워드를 사용한다.
OPTIMIZE TABLE phone;

DROP INDEX idx_name ON phone;
SHOW INDEX FROM phone;

