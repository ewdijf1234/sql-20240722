USE practice_sql;



CREATE TABLE sale (
	sequence_number INT PRIMARY KEY AUTO_INCREMENT,
    date DATE,
    amount INT,
    employee_number INT
);


INSERT INTO sale (date, amount, employee_number)
VALUES ('2024-07-01', 100000, 1);
INSERT INTO sale (date, amount, employee_number)
VALUES ('2024-07-01', 120000, 2);
INSERT INTO sale (date, amount, employee_number)
VALUES ('2024-07-03', 60000, 1);
INSERT INTO sale (date, amount, employee_number)
VALUES ('2024-07-03', 170000, 3);
INSERT INTO sale (date, amount, employee_number)
VALUES ('2024-07-06', 100000, 2);
INSERT INTO sale (date, amount, employee_number)
VALUES ('2024-07-07', 80000, 1);
INSERT INTO sale (date, amount, employee_number)
VALUES ('2024-07-08', 90000, 2);
INSERT INTO sale (date, amount, employee_number)
VALUES ('2024-07-08', 110000, 3);

SELECT * FROM sale ORDER BY employee_number;
-- 집계 함수 : 여러 행으 ㅣ레코드를 종합하여 하나의 결과값을 반환

-- COUNT() : 특정 조건에 해당하는 레코드의 개수를 반환
SELECT COUNT(*) FROM sale;
SELECT COUNT(*) FROM sale WHERE amount <= 100000;
SELECT COUNT(amount) FROM sale;

-- SUM() : 특정 조건에 해당하는 컬럼의 값을 모두 더한 결과를 반환
SELECT SUM(amount) FROM sale;
SELECT SUM(amount) FROM sale WHERE employee_number = 1;

-- AVG(0) : 특정 조건에 해당하는 컬럼의 값의 평균을 반환
SELECT AVG(amount) FROM sale;
SELECT AVG(amount) FROM sale WHERE employee_number = 1;

-- MAX(), MIN() : 특정 조건에 해당하는 컬럼 값의 최대 최소 값을 반환
SELECT MAX(amount), MIN(amount) FROM sale;
SELECT MAX(amount), MIN(amount) FROM sale WHERE employee_number = 1;

-- 그룹화 (GRUOP BY) : 조회 결과에 대해 레코드를 하나 이상의 컬럼으로 그룹화하여 결과를 도출하는 것
-- 일반적으로 집계함수와 함께 사용됨
SELECT AVG(amount), employee_number # 컬럼을 지정해주지 않았기 때문에 오류가 나서 GROUP BY를 사용하여 지정해주어야 한다.
FROM sale
GROUP BY employee_number; # 집계함수 처리를 각 각 따로 해주게 된다.

SELECT AVG(amount) # employee_number 제외하고 집계가 된다.
FROM sale
GROUP BY employee_number;

SELECT AVG(amount) , date # GRUOP BY 집계함수가 포함되어 있는 쿼리 혹은 그룹화가 되어있는 쿼리에서는 그룹화한 컬럼과 집계함수를 제외한 컬럼은 SELECT 절에서 사용이 불가능
FROM sale
GROUP BY employee_number;

SELECT AVG(amount) ,employee_number, date FROM sale GROUP BY employee_number, date;

-- 집계를 쓰지 않고 표현을 하면 중복을 제거하고 출력되게 된다.

-- 필터링 (HAVING) : 그룹화된 결과에 필터 작업을 수행
-- 주의!! WHERE 절과 사용방법이 비슷하지만 WHERE 절은 조회할 때 사용, HAVING 절은 조회 결과에 사용
SELECT AVG(amount) '평균', employee_number '사번' FROM sale  GROUP BY employee_number HAVING AVG(amount) <= 110000; # AVG(amount)를 평균으로 사용할 수 있다.
SELECT AVG(amount) '평균', employee_number '사번' FROM sale WHERE date < '2024-07-05' GROUP BY employee_number;
-- 결과 테이블에 존재하지 않는 컬럼은 HAVING 절에서 사용할 수 없음
SELECT AVG(amount) '평균', employee_number '사번' FROM sale  GROUP BY employee_number HAVING date < '2024-07-05' <= 110000; # 결과 테이블(SELECT)이 존재할 떄만 사용 가능하다.







