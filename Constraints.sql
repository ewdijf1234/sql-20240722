USE practice_sql;

-- 제약조건 : 데이터베이스 테이블 컬럼에 삽입, 수정, 삭제 시 적용되는 규칙
-- NOT NULL 제약조건 : 해당 컬럼에 null을 포함하지 못하도록 제약
CREATE TABLE not_null_table (
	null_column INT,
    not_null_column INT NOT NULL
);

-- NOT NULL 제약조건이 걸린 컬럼에 값을 지정하지 않음

INSERT INTO not_null_table (null_column) VALUES (1);
-- NOT NULL 제약조건이 걸린 컬럼에 null을 지정함.
INSERT INTO not_null_table VALUES(null,null);

INSERT INTO not_null_table VALUES (1,1);
INSERT INTO not_null_table VALUES (null,2);
INSERT INTO not_null_table (not_null_column) VALUES (2);

SELECT * FROM not_null_table;

UPDATE not_null_table SET not_null_column = null; 

-- NOT NULL + UNIQUE = 후보키
-- 후보키 : 테이블에서 각 레코드를 고유하게 식별할 수 있는 속성들
-- 기본키 : 테이블에서 각 레코드를 고유하게 식별하기 위해 후보키에서 선택한 속성
-- 대체키 : 후보키에서 기본키를 제외한 나머지 속성들

-- PRIMARY KEY 제약조건 : 특정 컬럼을 기본키로 지정
-- (INSERT, UPDATE)에 영향을 미친다.
CREATE TABLE key_table (
	primary_column INT PRIMARY KEY,
    surrogate_column INT NOT NULL UNIQUE
);

-- PRIMARY KEY 제약조건은 NOT NULL, UNIQUE 제약조건을 모두 가지고 있음
INSERT INTO key_table VALUES(null, 1);
INSERT INTO key_table (surrogate_column) VALUES (1);
INSERT INTO key_table VALUES (1,1);
INSERT INTO key_table VALUES (1,2); # 중복이 되어서 오류가 난다.

-- PRIMARY KEY 제약조건을 두 개 이상 지정 불가능
CREATE TABLE composite_table (
	primary1 INT PRIMARY KEY,
    primary2 INT PRIMARY KEY
);

CREATE TABLE composite_table (
	primary1 INT,
    primary2 INT,
    CONSTRAINT primary_key PRIMARY KEY (primary1, primary2)
);

-- FOREIGN KEY 제약조건 : 특정 컬럼을 다른 테이블 혹은 같은 테이블의 기본키 컬럼과 연결하는 제약
-- FOREIGN KEY 제약조건을 특정 컬럼에 적용할 때는 반드시 데이터 타입이 참조하고자하는 컬럼의 타입과 일치해야함
CREATE TABLE foreign_table (
	primary1 INT PRIMARY KEY,
    foreign1 INT, 
    CONSTRAINT foreign_key FOREIGN KEY(foreign1) # 제약조건 제약키이름 키종류 해당컬럼
    REFERENCES key_table(primary_column)
);

-- FOREIGN KEY 제약조건이 적용된 컬럼에는 참조하고 있는 테이블의 컬럼에 값이 존재하지 않으면 삽입, 수정이 불가능
INSERT INTO foreign_table VALUES (1,0);
INSERT INTO foreign_table VALUES (1,1);

UPDATE foreign_table SET foreign1 = 2 WHERE primary1 = 1;

-- FOREIGNKEY 제약조건으로 참조되어지고 있는 테이블의 레코드는 수정,삭제가 불가능
UPDATE key_table SET primary_column = 2 WHERE primary_column = 1;
DELETE FROM key_table WHERE primary_column = 1;

-- FOREIGN KEY 제약조건으로 참조되어지고 있는 테이블의 컬럼 변경 작업이 불가능
DROP TABLE key_table; # 제약조건이 걸려있기 때문에 수행이 불가능해진다.alter

ALTER TABLE key_table MODIFY COLUMN primary_column VARCHAR(10); # 같은 타입을 가져야 하기 때문에 추가 이외의 변경 등은 제약이 걸린다.

-- ON UPDATE / ON DELETE 옵션
-- ON UPDATE : 참조하고 있는 테이블의 기본키가 변경될 때 동작
-- ON DELETE : 참조하고 있는 테이블의 기본키가 삭제될 때 동작

-- CASCADE : 참조되고 있는 테이블의 데이터가 삭제 또는 수정된다면, 참조하고 있는 테이블에서도 삭제 또는 수정이 같이 일어남
-- SET NULL : 참조되고 있는 테이블의 데이터가 삭제 또는 수정된다면, 참조하고 있는 테이블의 데이터는 NULL로 지정됨
-- RESTRICT : 참조되고 있는 테이블의 데이터의 삭제 또는 수정을 불가능하게 함
CREATE TABLE optional_foreign_table (
	primary_column INT PRIMARY KEY,
	foreign_column INT,
    FOREIGN KEY (foreign_column) REFERENCES key_table (primary_column)
    ON UPDATE CASCADE 
    ON DELETE SET NULL
);

INSERT INTO optional_foreign_table VALUES (1,1);
SELECT * FROM optional_foreign_table;

UPDATE key_table SET primary_column = 2;

DROP TABLE foreign_table;

SELECT * FROM key_table;
SELECT * FROM optional_foreign_table;

DELETE FROM key_table;

-- CHECK 제약조건 : 해당 컬럼에 값을 제한하는 제약
CREATE TABLE check_table (
	primary_column INT PRIMARY KEY,
    check_column VARCHAR(5) CHECK(check_column IN ('남', '여'))
);

-- CHECK 제약조건이 걸린 컬럼에 조건에 해당하지 않은 값을 삽입, 수정할 수 없음
INSERT INTO check_table VALUES(1, '남');
INSERT INTO check_table VALUES(2, '남자'); 
UPDATE check_table SET check_column = '여자';

-- DEFAULT 제약조건 : 해당 컬럼에 삽입시 값이 지정되지 않으면 기본값으로 지정하는 제약
CREATE TABLE default_table (
-- AUTO_INCREMENT : 기본키가 정수형일 때 기본키의 값을 1씩 증가하는 값으로 자동 지정
	primary_column INT PRIMARY KEY AUTO_INCREMENT,
    column1 INT,
    default_column INT DEFAULT 10
);

INSERT INTO default_table (column1) VALUES (99);
SELECT * FROM default_table;
