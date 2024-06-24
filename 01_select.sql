SELECT * FROM tbl_menu;

SELECT
		 menu_code
	  , menu_name
	  , menu_price
	  , category_code
	  , orderable_status
  FROM tbl_menu;
  
SELECT
		 category_code
	  , category_name
	  , ref_category_code
	FROM tbl_category;
	
	
SELECT
		 menu_name
	  , category_name
	FROM tbl_menu
	JOIN tbl_category ON tbl_menu.category_code = tbl_category.category_code;
	
	
SELECT 7 + 3;
SELECT 10 * 2;
SELECT 6 % 3, 6 % 4;
SELECT NOW();
SELECT CONCAT('유', ' ', '관순');

-- SELECT CONCAT('메뉴 이름은 : ', menu_name) FROM tbl_menu;

SELECT 7 + 3 AS '합', 10 * 2 AS '곱';
SELECT NOW() AS '현재 시간';
SELECT 7 + 3 AS '합입니다.';
SELECT 7 + 3 AS 합입니다; -- 별칭에 특수기호가 있다면 ''을 반드시 추가한다.