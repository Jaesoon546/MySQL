# MySQL — 대전바이오융합 직업훈련

HeidiSQL에서 작성한 MySQL 실습 쿼리입니다. 파일 번호는 작성한 순서입니다.
이 DB(`jsdb`)를 파이썬에서 연결해 쓰는 코드는 [python 저장소의 10_pymysql_sungjuk.py](https://github.com/Jaesoon546/python/blob/main/lectures/10_pymysql_sungjuk.py)에 있습니다.

| 파일 | 내용 |
|---|---|
| [01_person_info_crud.sql](01_person_info_crud.sql) | person_info 테이블 기본 CRUD |
| [02_school_student_select_join.sql](02_school_student_select_join.sql) | school·student — WHERE/LIKE/IN, 서브쿼리, JOIN, GROUP BY, 변수, CASE/IF 학점 |
| [03_view_function_procedure_trigger.sql](03_view_function_procedure_trigger.sql) | 뷰, 날짜 함수, 사용자 함수, 프로시저·트리거 호출 |
| [04_emp_dept_create_tables.sql](04_emp_dept_create_tables.sql) | DEPT·EMP·BONUS·SALGRADE 예제 테이블 생성 + 데이터 |
| [05_hospital_patient_diagnosis.sql](05_hospital_patient_diagnosis.sql) | 병원·환자·진단 다대다 관계, GROUP_CONCAT |
| [06_emp_select_groupby_event.sql](06_emp_select_groupby_event.sql) | EMP 조회 문제, 문자열·숫자 함수, GROUP BY/HAVING, 이벤트 스케줄러 |
| [07_union_backup_trigger.sql](07_union_backup_trigger.sql) | UNION 과목별 통계, 백업 복원, 업데이트 백업 트리거 |
