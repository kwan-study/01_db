/* trigger */

DELIMITER //

CREATE OR REPLACE TRIGGER after_order_menu_insert
	AFTER INSERT
	ON tbl_order_menu
	FOR EACH row
BEGIN
	UPDATE tbl_order
	SET total_order_price = total_order_price + NEW.order_amount *
	(SELECT menu_price from tbl_menu WHERE menu_code = NEW.menu_code)
	WHERE order_code = NEW.order_code;
END//

DELIMITER ;
 
SHOW TRIGGERS;

-- 주문 테이블(tbl_order)에 insert 후 주문 메뉴 테이블(tbl_order_menu)에 주문한 메뉴마다
-- insert 후 주문 테이블의 총 금액이 업데이트 되는지 확인한다.

-- 1) 주문 테이블 insert
INSERT
  INTO tbl_order
(
  order_code, order_date
, order_time, total_order_price
)
VALUES
(
  NULL
, CONCAT(CAST(YEAR(NOW()) AS VARCHAR(4))
       , CAST(LPAD(MONTH(NOW()), 2, 0) AS VARCHAR(2))
       , CAST(LPAD(DAYOFMONTH(NOW()), 2, 0) AS VARCHAR(2))
       )
, CONCAT(CAST(LPAD(HOUR(NOW()), 2, 0) AS VARCHAR(2))
       , CAST(LPAD(MINUTE(NOW()), 2, 0) AS VARCHAR(2))
       , CAST(LPAD(SECOND(NOW()), 2, 0) AS VARCHAR(2))
       )
, 0    
);

SELECT * FROM tbl_order;

INSERT
  INTO tbl_order_menu
VALUES
(
  1
, 2
, 3
);

INSERT
  INTO tbl_order_menu
VALUES
(
  1
, 6
, 2
);


/* 상품 입출고와 관련된 trigger 활용 예제 */
-- 1) 이력 테이블(update가 발생하는 테이블)
CREATE TABLE product (
  pcode INT PRIMARY KEY AUTO_INCREMENT,
  pname VARCHAR(30),
  brand VARCHAR(30),
  price INT,
  stock INT DEFAULT 0,
  CHECK(stock >= 0)
);
-- 2) 내역 테이블(insert가 발생하는 테이블)
CREATE TABLE pro_detail (
  dcode INT PRIMARY KEY AUTO_INCREMENT,
  pcode INT,
  pdate DATE,
  amount INT,
  STATUS VARCHAR(10) CHECK(STATUS IN ('입고', '출고')),
  FOREIGN KEY(pcode) REFERENCES product		-- 부모 테이블의 pk가 넘어오는게 당연하므로
  															-- 생략 가능
);

DELIMITER //
CREATE OR REPLACE TRIGGER trg_productafter
	AFTER INSERT
	ON pro_detail
	FOR EACH row
BEGIN
	if NEW.status = '입고' then
	  UPDATE product
	  	  SET stock = stock + NEW.amount
	  	WHERE pcode = NEW.pcode;
	ELSEIF NEW.status = '출고' then
	  UPDATE product
	     SET stock = stock - NEW.amount
	   WHERE pcode = NEW.pcode;
	END if;
END //

DELIMITER ;

SHOW TRIGGERS;

-- product 테이블에 상품 추가
INSERT
  INTO product
(
  pcode, pname, brand
, price, stock
)
VALUES
(
  NULL, '갤럭시플립', '삼송'
, 900000, 5
);

INSERT
  INTO product
(
  pcode, pname, brand
, price, stock
)
VALUES
(
  NULL, '아이펀15', '아이뽕'
, 1100000, 5
);

INSERT
  INTO product
(
  pcode, pname, brand
, price, stock
)
VALUES
(
  NULL, '투명폰', '삼송'
, 2100000, 5
);

SELECT * FROM product;

-- 존재하는 상품들에 대한 입출고 진행
INSERT
  INTO pro_detail
(
  dcode, pcode, pdate
, amount, STATUS
)
VALUES
(
  NULL, 3, CURDATE()
, 5, '입고'
);

INSERT
  INTO pro_detail
(
  dcode, pcode, pdate
, amount, STATUS
)
VALUES
(
  NULL, 2, CURDATE()
, 3, '출고'
);