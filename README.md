# MySQL — 대전바이오융합 직업훈련

![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?logo=mysql&logoColor=white)
![HeidiSQL](https://img.shields.io/badge/Tool-HeidiSQL-6AA84F)

HeidiSQL에서 작성한 MySQL 실습 쿼리입니다. 사용한 테이블별로 폴더를 나눴고, 파일 번호는 작성한 순서입니다.
이 DB(`jsdb`)를 파이썬에서 연결해 쓰는 코드는 [python 저장소의 10_pymysql_sungjuk.py](https://github.com/Jaesoon546/python/blob/main/lectures/10_pymysql_sungjuk.py)에 있습니다.

```
MySQL/
├── person_info/      # 개인정보 테이블 기본 CRUD
├── school_student/   # 학교·학생 성적 DB (jsdb)
├── emp_dept/         # 사원·부서 예제 DB
└── hospital/         # 병원·환자·진단 DB
```

### person_info/
| 파일 | 내용 |
|---|---|
| [01_person_info_crud.sql](person_info/01_person_info_crud.sql) | INSERT / SELECT / UPDATE / DELETE 기본 |

### school_student/
| 파일 | 내용 |
|---|---|
| [02_school_student_select_join.sql](school_student/02_school_student_select_join.sql) | WHERE/LIKE/IN, 서브쿼리, JOIN, GROUP BY, 변수, CASE/IF 학점 |
| [03_view_function_procedure_trigger.sql](school_student/03_view_function_procedure_trigger.sql) | 뷰, 날짜 함수, 사용자 함수, 프로시저·트리거 호출 |
| [07_union_backup_trigger.sql](school_student/07_union_backup_trigger.sql) | UNION 과목별 통계, 백업 복원, 업데이트 백업 트리거 |

### emp_dept/
| 파일 | 내용 |
|---|---|
| [04_emp_dept_create_tables.sql](emp_dept/04_emp_dept_create_tables.sql) | DEPT·EMP·BONUS·SALGRADE 테이블 생성 + 데이터 |
| [06_emp_select_groupby_event.sql](emp_dept/06_emp_select_groupby_event.sql) | 조회 문제, 문자열·숫자 함수, GROUP BY/HAVING, 이벤트 스케줄러 |

### hospital/
| 파일 | 내용 |
|---|---|
| [05_hospital_patient_diagnosis.sql](hospital/05_hospital_patient_diagnosis.sql) | 병원·환자·진단 다대다 관계, GROUP_CONCAT |
