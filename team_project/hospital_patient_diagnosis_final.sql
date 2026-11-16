--  병원(hospital) / 환자(patient) / 병명(diagnosis) / 진료연결(chaintable)
--  테이블 구조
--    hospital   : hospitalid(PK) VARCHAR(10), name VARCHAR(10)
--    patient    : patientid(PK) VARCHAR(5), name VARCHAR(30), sex CHAR(1), age TINYINT
--    diagnosis  : dxcode(PK) VARCHAR(4), dxname VARCHAR(100)
--    chaintable : no(PK, AUTO_INCREMENT), hospitalid, patientid, dxcode (각각 FK)

-- SELECT * FROM hospital;
-- SELECT * FROM patient;
-- SELECT * FROM diagnosis;
-- SELECT * FROM chaintable;

-- DELETE FROM chaintable;
-- DELETE FROM patient;
-- DELETE FROM diagnosis;
-- DELETE FROM hospital;

# 병원 3곳 입력 (H3: 환자가 없는 병원)
INSERT INTO hospital VALUES ('H1', '대전병원'), ('H2', '서울병원'), ('H3', '부산병원');

# 환자 11명 입력 (P0011: 나이를 모르는 환자 → NULL)
INSERT INTO patient VALUES
('P0001', '박재순', 'M', 27), ('P0002', '박지희', 'F', 24),
('P0003', '김성민', 'F', 30), ('P0004', '김현준', 'M', 36),
('P0005', '김대한', 'M', 28), ('P0006', '김민국', 'F', 25),
('P0007', '박철학', 'F', 31), ('P0008', '이수학', 'M', 37),
('P0009', '김만세', 'M', 29), ('P0010', '물방울', 'F', 26),
('P0011', '홍길동', 'M', NULL);

# 병명 10개 입력
INSERT INTO diagnosis VALUES
('D001', '감기'), ('D002', '비염'), ('D003', '위염'),
('D004', '역류성식도염'), ('D005', '고혈압'), ('D006', '당뇨병'),
('D007', '고지혈증'), ('D008', '요통'), ('D009', '대상포진'),
('D010', '코로나');

# 진료 기록 15건 입력 (한 환자가 여러 병, 한 환자가 여러 병원)
INSERT INTO chaintable (hospitalid, patientid, dxcode) VALUES
('H1', 'P0001', 'D001'), ('H1', 'P0001', 'D002'), ('H1', 'P0001', 'D005'),  -- 박재순: 병 3개
('H1', 'P0002', 'D002'), ('H1', 'P0002', 'D003'),                           -- 박지희: 병 2개
('H1', 'P0003', 'D001'),
('H2', 'P0004', 'D005'), ('H2', 'P0004', 'D006'), ('H2', 'P0004', 'D007'),  -- 김현준: 병 3개
('H2', 'P0005', 'D010'),
('H1', 'P0006', 'D002'),
('H2', 'P0007', 'D004'),
('H2', 'P0008', 'D008'), ('H1', 'P0008', 'D008'),                           -- 이수학: 두 병원에서 같은 병
('H2', 'P0009', 'D001');
-- P0010 물방울, P0011 홍길동: 진료 기록 없음
-- D009 대상포진: 진단받은 환자 없음

# 입력이 안됨 -- 기본키(병원코드)가 중복
-- INSERT INTO hospital VALUES ('H1', '청주병원');

# 입력이 안됨 -- patient에 없는 환자 (외래키 1452)
-- INSERT INTO chaintable (hospitalid, patientid, dxcode) VALUES ('H1', 'P9999', 'D001');

SELECT * FROM hospital;
SELECT * FROM patient WHERE patientid = 'P0001';



-- 1. 기본 조회

SELECT name, sex, age FROM patient WHERE name = '박재순';

# 별칭
SELECT name AS '이름', sex AS '성별', age AS '나이'
FROM patient WHERE name = '박재순';
SELECT patientid, dxcode FROM chaintable WHERE patientid = 'P0001';

# in 연산자 ( 포함 )
SELECT * FROM diagnosis
WHERE dxcode IN ('D001', 'D002', 'D010');

# subquery ( 괄호로 묶어줌 ) -- 진료 기록이 있는 환자만
SELECT name, sex, age FROM patient
WHERE patientid IN (SELECT patientid FROM chaintable);

# 문자검색 ( % : 여러 문자, _ : 한 문자 )
SELECT * FROM patient WHERE name LIKE '김%';     -- 예상: 5명
SELECT * FROM patient WHERE name LIKE '%민%';    -- 예상: 김성민, 김민국
SELECT * FROM patient WHERE name LIKE '_수_';    -- 예상: 이수학
SELECT * FROM diagnosis WHERE dxname LIKE '%염'; -- 예상: 비염, 위염, 역류성식도염

# 논리연산자
SELECT * FROM patient WHERE sex = 'F' AND age >= 30;   -- 예상: 김성민, 박철학
SELECT * FROM patient WHERE age < 25 OR age > 35;      -- 예상: 박지희, 김현준, 이수학

# NULL 비교 ( = NULL 은 항상 거짓 → IS NULL )
SELECT * FROM patient WHERE age = NULL;    -- 결과 없음
SELECT * FROM patient WHERE age IS NULL;   -- 예상: 홍길동

# 출력 수를 제한
SELECT * FROM patient WHERE age BETWEEN 25 AND 35 LIMIT 3;

# 중복을 제거하고 -- 진료 기록이 있는 환자 ID
SELECT DISTINCT patientid FROM chaintable;

# 함수의 사용
SELECT COUNT(*) AS '환자수' FROM patient;                     -- 예상: 11
SELECT CONCAT(name, '님') AS '이름', age AS '나이' FROM patient WHERE name = '물방울';
SELECT CONCAT(name, '(', sex, ', ', age, '세)') AS '환자정보' FROM patient;



-- 문제 1


# 전체 환자를 이름 기준으로 내림차순으로 출력
SELECT * FROM patient ORDER BY name DESC;

# 나이가 많은 순으로 3명만 출력 (NULL 은 정렬 시 가장 작은 값으로 취급)
SELECT * FROM patient ORDER BY age DESC LIMIT 3;

# 진료 기록에서 병명코드를 중복 없이 출력
SELECT DISTINCT dxcode FROM chaintable ORDER BY dxcode;

# 환자의 이름, 진료받은 병원 이름을 출력 (join)
SELECT p.name AS 환자, h.name AS 병원
FROM chaintable c
INNER JOIN patient  p ON c.patientid  = p.patientid   -- join 의 조건은 ON
INNER JOIN hospital h ON c.hospitalid = h.hospitalid;

# 환자 이름, 병원 이름, 병명을 출력 (3개 테이블 join)
SELECT p.name AS 환자, h.name AS 병원, d.dxname AS 병명
FROM chaintable c
JOIN patient   p ON c.patientid  = p.patientid
JOIN hospital  h ON c.hospitalid = h.hospitalid
JOIN diagnosis d ON c.dxcode     = d.dxcode
ORDER BY c.no;



-- 2. 집계 함수와 NULL


# 환자 나이의 합계, 평균, 최대, 최소
SELECT SUM(age), AVG(age), MAX(age), MIN(age) FROM patient;

-- COUNT(*) 는 모든 행, COUNT(컬럼) 은 NULL 을 제외
SELECT COUNT(*) AS 전체, COUNT(age) AS 나이있는환자 FROM patient;   -- 예상: 11, 10

-- 연산의 원칙에 연산시 NULL이 하나라도 있으면 결과는 NULL
-- 10 + NULL -> 결과 NULL
SELECT name, age + 1 AS 내년나이 FROM patient;               -- 홍길동은 NULL

# 변수와 초기값 ( NULL 이면 0 으로 )
SELECT name, IFNULL(age, 0) + 1 AS 내년나이 FROM patient;
SELECT name, IFNULL(CAST(age AS CHAR), '미상') AS 나이 FROM patient;

# 성별로 환자 수와 평균 나이
SELECT sex, COUNT(*) AS 환자수, ROUND(AVG(age), 1) AS 평균나이
FROM patient GROUP BY sex;

# 병원별로 진료 건수
SELECT hospitalid, COUNT(*) AS 진료건수 FROM chaintable GROUP BY hospitalid;

# 병원별로 진료 건수와 환자 수 ( 같은 환자는 한 번만 )
SELECT hospitalid, COUNT(*) AS 진료건수, COUNT(DISTINCT patientid) AS 환자수
FROM chaintable GROUP BY hospitalid;
-- 예상: H1 8건 5명, H2 7건 5명

# 병원 이름별로 진료 건수와 환자 수
SELECT h.name AS 병원, COUNT(*) AS 진료건수, COUNT(DISTINCT c.patientid) AS 환자수
FROM hospital h JOIN chaintable c ON c.hospitalid = h.hospitalid
GROUP BY h.hospitalid, h.name;

# 위 계산을 대전병원에 적용 ( WHERE 는 GROUP BY 앞에 )
SELECT h.name AS 병원, COUNT(*) AS 진료건수, COUNT(DISTINCT c.patientid) AS 환자수
FROM hospital h
JOIN chaintable c ON c.hospitalid = h.hospitalid
WHERE h.name = '대전병원'
GROUP BY h.hospitalid, h.name;

# 환자가 없는 병원도 0 으로 출력 ( LEFT JOIN )
SELECT h.name AS 병원, COUNT(c.no) AS 진료건수
FROM hospital h LEFT JOIN chaintable c ON c.hospitalid = h.hospitalid
GROUP BY h.hospitalid, h.name;
-- 예상: 부산병원 0  ( COUNT(*) 로 쓰면 1 이 나옴 → 주의 )

# 병명별 환자 수, 많은 순 ( HAVING : 묶은 결과에 조건 )
SELECT d.dxname AS 병명, COUNT(DISTINCT c.patientid) AS 환자수
FROM diagnosis d JOIN chaintable c ON c.dxcode = d.dxcode
GROUP BY d.dxcode, d.dxname
HAVING COUNT(DISTINCT c.patientid) >= 2
ORDER BY 환자수 DESC;
-- 예상: 감기 3, 비염 3, 고혈압 2



-- 3. 변수 사용법
--    @@ : 시스템변수, @ : 사용자 변수

SELECT hospitalid INTO @hid FROM hospital WHERE name = '서울병원';
SELECT @hid;
SELECT * FROM chaintable WHERE hospitalid = @hid;

-- 같은 결과를 서브쿼리로
SELECT * FROM chaintable
WHERE hospitalid = ( SELECT hospitalid FROM hospital
                     WHERE name = '서울병원');

-- 병명으로 환자 찾기
SELECT dxcode INTO @dx FROM diagnosis WHERE dxname = '감기';
SELECT p.name FROM chaintable c JOIN patient p ON c.patientid = p.patientid
WHERE c.dxcode = @dx;                                      -- 예상: 박재순, 김성민, 김만세

SELECT @@version, @@autocommit;                            -- 시스템 변수



-- 4. 테이블 백업


-- 대전병원 진료 기록만 백업 ( 데이터만 복사, PK·인덱스·외래키는 복사 안 됨 )
DROP TABLE IF EXISTS daejeon_backup;
CREATE TABLE IF NOT EXISTS daejeon_backup AS
    SELECT * FROM chaintable
        WHERE hospitalid = ( SELECT hospitalid FROM hospital
            WHERE name = '대전병원');

ALTER TABLE daejeon_backup ADD PRIMARY KEY (no);

-- 구조까지 똑같이 백업 ( PK, 인덱스, AUTO_INCREMENT 포함 / 외래키는 제외 )
DROP TABLE IF EXISTS patient_backup;
CREATE TABLE patient_backup LIKE patient;
INSERT INTO patient_backup SELECT * FROM patient;

SHOW INDEX FROM daejeon_backup;
SHOW INDEX FROM patient_backup;



-- 5. 빈 필드 채우기 ( 병 개수와 상태 )
--    실습 코드의 total / average 처럼 계산한 값을 컬럼에 저장


-- 컬럼 추가 (이미 있으면 1060 오류 → 무시하고 진행)
ALTER TABLE patient ADD COLUMN dxcount TINYINT;
ALTER TABLE patient ADD COLUMN status  VARCHAR(10);

-- 모든 필드에 적용 : 환자별 병 개수 (같은 병은 한 번만)
UPDATE patient p
SET dxcount = ( SELECT COUNT(DISTINCT c.dxcode) FROM chaintable c
                WHERE c.patientid = p.patientid );

SELECT name, dxcount FROM patient;
-- 예상: 박재순 3, 박지희 2, 김현준 3, 이수학 1, 물방울 0, 홍길동 0 ...

-- 이름과 상태를 출력 ( CASE )
SELECT name, dxcount,
       (CASE WHEN dxcount >= 3 THEN '집중관리'
             WHEN dxcount = 2  THEN '주의'
             WHEN dxcount = 1  THEN '관찰'
             ELSE '건강' END) AS '상태'
FROM patient;

-- 3항 연산자 ( if 조건, 참일때, 거짓일 때 )
SELECT name, dxcount,
       IF(dxcount >= 3, '집중관리',
       IF(dxcount = 2,  '주의',
       IF(dxcount = 1,  '관찰', '건강'))) AS '상태'
FROM patient;



-- 문제 2


# 상태를 병 개수로 판정해서 수정하시오
UPDATE patient
SET status = IF(dxcount >= 3, '집중관리',
             IF(dxcount = 2,  '주의',
             IF(dxcount = 1,  '관찰', '건강')));

SELECT * FROM patient;

# 연령대 컬럼을 추가하고 나이로 채우시오 ( NULL 이면 '미상' )
ALTER TABLE patient ADD COLUMN agegroup VARCHAR(10);
UPDATE patient
SET agegroup = CASE WHEN age IS NULL THEN '미상'
                    WHEN age < 30    THEN '20대'
                    WHEN age < 40    THEN '30대'
                    ELSE '40대 이상' END;

SELECT agegroup, COUNT(*) FROM patient GROUP BY agegroup;
-- 예상: 20대 6, 30대 4, 미상 1

# 추가한 컬럼 삭제 (필요할 때)
-- ALTER TABLE patient DROP COLUMN agegroup;



-- 문제 3

# 병원 이름을 출력하고 환자들의 이름, 성별, 나이, 병 개수, 병명 목록, 상태를
# 진료 기록(chaintable)으로부터 계산해서 출력
--  (저장된 dxcount 컬럼이 아니라 직접 계산 / 같은 SELECT 안에서는 별칭을 쓸 수 없어서 서브쿼리 사용)
SELECT 병원, 환자, 성별, 나이, 병개수, 병명,
       IF(병개수 >= 3, '집중관리',
       IF(병개수 = 2,  '주의', '관찰')) AS 상태
FROM (
    SELECT h.name AS 병원, p.name AS 환자, p.sex AS 성별, p.age AS 나이,
           COUNT(DISTINCT c.dxcode) AS 병개수,
           GROUP_CONCAT(d.dxname ORDER BY d.dxcode SEPARATOR ', ') AS 병명
    FROM chaintable c
    JOIN hospital  h ON c.hospitalid = h.hospitalid
    JOIN patient   p ON c.patientid  = p.patientid
    JOIN diagnosis d ON c.dxcode     = d.dxcode
    GROUP BY h.hospitalid, h.name, p.patientid, p.name, p.sex, p.age
) AS t
ORDER BY 병원, 환자;

# 진료 기록이 없는 환자도 포함해서, 환자별 병명 목록 (없으면 '기록 없음')
SELECT p.name AS 환자,
       IFNULL(GROUP_CONCAT(DISTINCT d.dxname SEPARATOR ', '), '기록 없음') AS 병명
FROM patient p
LEFT JOIN chaintable c ON p.patientid = c.patientid
LEFT JOIN diagnosis  d ON c.dxcode    = d.dxcode
GROUP BY p.patientid, p.name;

# 두 병원을 모두 다닌 환자 (예상: 이수학)
SELECT p.name, GROUP_CONCAT(DISTINCT h.name SEPARATOR ', ') AS 병원
FROM chaintable c
JOIN patient  p ON c.patientid  = p.patientid
JOIN hospital h ON c.hospitalid = h.hospitalid
GROUP BY p.patientid, p.name
HAVING COUNT(DISTINCT c.hospitalid) = 2;

# 아무도 진단받지 않은 병 (예상: 대상포진)
SELECT d.* FROM diagnosis d
LEFT JOIN chaintable c ON d.dxcode = c.dxcode
WHERE c.dxcode IS NULL;

# 병명별 환자 목록 ( GROUP_CONCAT )
SELECT d.dxname AS 병명,
       GROUP_CONCAT(DISTINCT p.name ORDER BY p.name SEPARATOR ', ') AS 환자들
FROM chaintable c
JOIN patient   p ON c.patientid = p.patientid
JOIN diagnosis d ON c.dxcode    = d.dxcode
GROUP BY d.dxcode, d.dxname;



-- 문제 4 : 함수

# 나이를 입력받아 연령대를 리턴하는 함수 ( IF ~ ELSEIF )
DROP FUNCTION IF EXISTS calc_agegroup;
DELIMITER $$
CREATE FUNCTION calc_agegroup(p_age TINYINT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF p_age IS NULL THEN
        RETURN '미상';
    ELSEIF p_age < 30 THEN
        RETURN '20대';
    ELSEIF p_age < 40 THEN
        RETURN '30대';
    ELSE
        RETURN '40대 이상';
    END IF;
END $$
DELIMITER ;

SELECT calc_agegroup(27);                                     -- 예상: 20대
SELECT name, age, calc_agegroup(age) AS 연령대 FROM patient;

# 환자ID를 입력받아 병 개수를 세고 상태를 리턴하는 함수
DROP FUNCTION IF EXISTS calc_status;
DELIMITER $$
CREATE FUNCTION calc_status(p_patientid VARCHAR(5))
RETURNS VARCHAR(10)
READS SQL DATA
BEGIN
    DECLARE cnt INT;
    SELECT COUNT(DISTINCT dxcode) INTO cnt
    FROM chaintable WHERE patientid = p_patientid;

    IF cnt >= 3 THEN
        RETURN '집중관리';
    ELSEIF cnt = 2 THEN
        RETURN '주의';
    ELSEIF cnt = 1 THEN
        RETURN '관찰';
    ELSE
        RETURN '건강';
    END IF;
END $$
DELIMITER ;

SELECT calc_status('P0001');                                  -- 예상: 집중관리
SELECT name, calc_status(patientid) AS 상태 FROM patient;



-- 문제 5 : 프로시저

# 환자를 입력하는 프로시저 ( 매개변수 4개 )
DROP PROCEDURE IF EXISTS patient_insert;
DELIMITER $$
CREATE PROCEDURE patient_insert(
    IN p_id   VARCHAR(5),
    IN p_name VARCHAR(30),
    IN p_sex  CHAR(1),
    IN p_age  TINYINT
)
BEGIN
    INSERT INTO patient(patientid, name, sex, age) VALUES (p_id, p_name, p_sex, p_age);
END $$
DELIMITER ;

-- 값의 개수·순서가 매개변수와 같아야 함 (다르면 1318 오류)
CALL patient_insert('P0012', '신입환자', 'F', 33);
SELECT * FROM patient WHERE patientid = 'P0012';

# 병명 여러 개를 한 번에 진료 기록으로 입력하는 프로시저
#   p_dxlist 에 'D001,D003' 또는 '감기,위염' 처럼 쉼표로 넘김
#   p_count 로 몇 건 들어갔는지 돌려받음 ( OUT 매개변수 )
DROP PROCEDURE IF EXISTS record_insert;
DELIMITER $$
CREATE PROCEDURE record_insert(
    IN  p_hospitalid VARCHAR(10),
    IN  p_patientid  VARCHAR(5),
    IN  p_dxlist     VARCHAR(200),
    OUT p_count      INT
)
BEGIN
    INSERT INTO chaintable (hospitalid, patientid, dxcode)
    SELECT p_hospitalid, p_patientid, d.dxcode
    FROM diagnosis d
    WHERE FIND_IN_SET(d.dxcode, REPLACE(p_dxlist, ' ', '')) > 0
       OR FIND_IN_SET(d.dxname, REPLACE(p_dxlist, ' ', '')) > 0;

    SET p_count = ROW_COUNT();
END $$
DELIMITER ;

CALL record_insert('H2', 'P0012', '감기, 위염, 요통', @cnt);
SELECT @cnt AS 입력건수;                                       -- 예상: 3
SELECT * FROM chaintable WHERE patientid = 'P0012';

# 병원 이름을 넣으면 진료 현황을 보여 주는 프로시저
DROP PROCEDURE IF EXISTS hospital_report;
DELIMITER $$
CREATE PROCEDURE hospital_report(IN p_name VARCHAR(10))
BEGIN
    SELECT p.name AS 환자, p.sex AS 성별, p.age AS 나이,
           GROUP_CONCAT(d.dxname SEPARATOR ', ') AS 병명
    FROM chaintable c
    JOIN hospital  h ON c.hospitalid = h.hospitalid
    JOIN patient   p ON c.patientid  = p.patientid
    JOIN diagnosis d ON c.dxcode     = d.dxcode
    WHERE h.name = p_name
    GROUP BY p.patientid, p.name, p.sex, p.age;
END $$
DELIMITER ;

CALL hospital_report('대전병원');
CALL hospital_report('부산병원');   -- 결과 없음 (환자 없는 병원)



-- 6. 뷰 ( 자주 쓰는 3개 테이블 join 을 저장 )

CREATE OR REPLACE VIEW v_record AS
SELECT c.no, h.name AS hospital, p.patientid, p.name AS patient,
       p.sex, p.age, d.dxcode, d.dxname
FROM chaintable c
JOIN hospital  h ON c.hospitalid = h.hospitalid
JOIN patient   p ON c.patientid  = p.patientid
JOIN diagnosis d ON c.dxcode     = d.dxcode;

SELECT * FROM v_record WHERE hospital = '서울병원';
SELECT dxname, COUNT(*) FROM v_record GROUP BY dxname;


-- 7. 트랜잭션 ( 수정해 보고 ROLLBACK 으로 되돌리기 )

START TRANSACTION;

UPDATE patient SET age = age + 1;                             -- 모두 한 살 더
DELETE FROM chaintable WHERE patientid = 'P0001';             -- 진료 기록 먼저 지워야
DELETE FROM patient    WHERE patientid = 'P0001';             -- 환자 삭제 가능
SELECT * FROM patient;

ROLLBACK;                                                      -- 위 변경 모두 취소
SELECT * FROM patient WHERE patientid = 'P0001';              -- 예상: 박재순, 27세 그대로