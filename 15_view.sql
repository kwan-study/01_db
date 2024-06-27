/* view */
-- table을 활용한 가상 table
-- view는 원본 테이블을 참조해서 보여주는 용도이고
-- 보여지는건 실제 테이블(Base Table)의 값이다.
SELECT
		 menu_name
	  , menu_price
  FROM tbl_menu;

DROP VIEW v_menu;
CREATE VIEW v_menu
AS
SELECT
		 menu_name AS '메뉴명'
	  , menu_price AS '메뉴단가'
  FROM tbl_menu;
  
SELECT * FROM v_menu;

CREATE or replace VIEW v_menu     -- drop 없이 다시 만들 수 있음
AS
SELECT
		 menu_name AS '메뉴명'
	  , menu_price AS '메뉴단가'
  FROM tbl_menu;
  
/* view를 통한 DML(절대 비추! 본래 용도가 아님) */
-- base table
SELECT * FROM tbl_menu;

-- view 생성
CREATE OR REPLACE VIEW hansik
AS
SELECT
		 menu_code
	  , menu_name
	  , menu_price
	  , category_code
	  , orderable_status
  FROM tbl_menu
 WHERE category_code = 4;
 
SELECT * FROM hansik;

-- hansik view를 통해 tbl_menu라는 base table에 영향을 줌
INSERT
  INTO hansik
VALUES
(NULL, '식혜국밥', 5500, 4, 'Y');

UPDATE hansik
   SET menu_name = '버터국밥'
     , menu_price = 6000
 WHERE menu_name = '식혜국밥';
 
SELECT * FROM tbl_menu;

CREATE OR REPLACE VIEW v_test
AS
SELECT
		 AVG(menu_price) + 3
  FROM tbl_menu;

SELECT * FROM v_test;

INSERT
  INTO v_test 
VALUES (10); -- view에 삽입 불가능(기본 테이블에 있던 내용이 아닌 집계함수로 새로 계산된 뷰)


