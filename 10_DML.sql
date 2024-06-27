/* DML(Data Manipulation Language */

-- insert, update, delete, select(DQL)

/* INSERT */
-- 새로운 행을 추가하는 구문이다.
-- 테이블의 행의 수가 증가
SELECT * FROM tbl_menu;
INSERT
  INTO tbl_menu
(
  menu_name
, menu_price
, category_code
, orderable_status
)
VALUES 
(
  '초콜릿죽'
, 6500
, 7
, 'Y'
);
SELECT * FROM tbl_menu ORDER BY 1 DESC;

/* multi insert */
INSERT
  INTO tbl_menu
VALUES
(NULL, '참치맛아이스크림', 1700, 12, 'Y'),
(NULL, '멸치맛아이스크림', 1500, 12, 'Y'),
(NULL, '소시지맛커피', 2500, 8, 'Y');

/* UPDATE */
-- 테이블에 기록된 컬럼값을 수정하는 구문
-- 전체 행 개수에는 변화가 없다.
SELECT
		 *
  FROM tbl_menu
 WHERE menu_name = '소시지맛커피';
 
UPDATE tbl_menu
	SET category_code = 7
 WHERE menu_code = 25;
 
-- subquery를 활용한 update
UPDATE tbl_menu
   SET category_code = 6
 WHERE menu_code = (SELECT menu_code
 							 FROM tbl_menu
							WHERE menu_name = '소시지맛커피');
							
/* DELETE */
-- 테이블의 행을 삭제하는 구문
-- 테이블의 행의 개수가 줄어든다.
SELECT * FROM tbl_menu;
DELETE 
  FROM tbl_menu
ROLLBACK;

-- MySQL 또는 MariaDB는 autocommit이 기본적으로 'on'이라 insert, update, delete
-- 시에 베이스 테이블에(메모리에)바로 반영된다.
-- 다시 살리고 싶다면 autocommit을 꺼주어야 한다.
SET autocommit = OFF;

DELETE
  FROM tbl_menu
 ORDER BY menu_price   -- 메뉴 가격 기준 오름차순
 LIMIT 2;				  -- 정렬된 첫 행부터 두개의 행에 해당
 
/* replace */
-- insert 시에 primary key(null X, 중복 X, 이후 수정 X) 또는 unique key(중복 X)가
-- 충돌이 발생하지 않도록 replace를 통해 중복된 데이터는 덮어 씌울 수 있다.

-- REPLACE tbl_menu -> into 생략 가능
REPLACE 
   INTO tbl_menu
 VALUES 
 (
   17
 , '참기름 소주'
 , 5000
 , 10
 , 'Y'
 );
SELECT * FROM tbl_menu WHERE menu_code = 17; 