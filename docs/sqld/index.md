# SQLD 시험 대비 노트

> 데이터 엔지니어를 향한 첫 번째 자격증 — SQL의 기본기를 다지는 가장 빠른 길.

---

## 시험 정보

| 항목 | 내용 |
|---|---|
| 시험명 | SQL 개발자 (SQLD) |
| 시행처 | 한국데이터산업진흥원 |
| 목표 시험일 | **2026년 8월 22일 (제62회)** |
| 접수 시기 | 7월 중순경 |
| 응시료 | 50,000원 |
| 합격 기준 | 총점 60점 이상 + 과목별 40% 이상 |
| 출제 형식 | 객관식 50문항 / 90분 |

---

## 출제 비중

| 과목 | 문항 수 | 비중 |
|---|---|---|
| 1과목. 데이터 모델링의 이해 | 10 | 20% |
| 2과목. SQL 기본 및 활용 | 40 | 80% |

> **2024년 개정 신규 항목**: PIVOT/UNPIVOT, 정규표현식, TOP N 쿼리

---

## 학습 순서

### 1과목 — 데이터 모델링
- [01. 데이터 모델링의 이해](01_데이터_모델링.md) — 엔터티·속성·관계·식별자, ERD, 함수적 종속성
- [02. 정규화 & 반정규화](02_정규화_반정규화.md) — 1NF/2NF/3NF/BCNF, 슈퍼/서브타입

### 2과목 — SQL 기본
- [03. DDL · DML · TCL](03_DDL_DML_TCL.md) — 테이블 관리, 트랜잭션 격리성, 제약조건
- [04. WHERE 절 & 함수](04_WHERE_함수.md) — 연산자, 함수, CASE/DECODE
- [05. GROUP BY · ORDER BY](05_GROUP_BY_ORDER_BY.md) — 집계, 정렬, **SELECT 실행순서**

### 2과목 — SQL 활용
- [06. JOIN](06_JOIN.md) — INNER/OUTER/NATURAL/CROSS, 집합 연산자
- [07. 서브쿼리 & 계층형](07_서브쿼리_계층형.md) — 스칼라/인라인뷰, CONNECT BY 가상칼럼
- [08. 윈도우 함수 · TOP-N · DCL](08_윈도우함수_그룹함수.md) — RANK, WINDOWING, ROWNUM/FETCH, **WITH GRANT/ADMIN OPTION**

### 2과목 — 2024 개정 신규
- [09. PIVOT · UNPIVOT](09_PIVOT_UNPIVOT.md) — LONG↔WIDE 데이터 변환
- [10. 정규표현식](10_정규표현식.md) — REGEXP_LIKE/REPLACE/SUBSTR/INSTR

### 관리 구문
- [11. DB 오브젝트](11_오브젝트_시퀀스_시노님.md) — View, Sequence, Synonym

---

## 시험 직전 핵심 암기

| 주제 | 핵심 |
|---|---|
| ACID | 원자성·일관성·고립성·지속성 |
| SELECT 실행순서 | FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY |
| 격리성 이슈 | Dirty Read / Non-Repeatable / Phantom |
| NULL | 비교연산은 FALSE, 수치연산은 NULL |
| RANK 종류 | RANK / DENSE_RANK / ROW_NUMBER 차이 |
| LAST_VALUE | WINDOWING 절 명시 안 하면 현재 행 반환 |
| JOIN | INNER vs OUTER vs CROSS, USING vs ON |
| 식별자 특징 | 유일성·최소성·불변성·존재성 |
| 정규화 | 1NF(원자값) → 2NF(부분종속 제거) → 3NF(이행종속 제거) |
| 슈퍼/서브타입 | OneToOne / Plus / Single Type |
| ROWNUM | 조건에 1 포함되어야 동작 |
| 권한 옵션 | WITH GRANT OPTION (객체, CASCADE) / WITH ADMIN OPTION (시스템, 독립) |

---

## 학습 진도 체크

- [ ] 01. 데이터 모델링
- [ ] 02. 정규화 & 반정규화
- [ ] 03. DDL · DML · TCL
- [ ] 04. WHERE 절 & 함수
- [ ] 05. GROUP BY · ORDER BY
- [ ] 06. JOIN
- [ ] 07. 서브쿼리 & 계층형
- [ ] 08. 윈도우 함수 · DCL
- [ ] 09. PIVOT · UNPIVOT
- [ ] 10. 정규표현식
- [ ] 11. DB 오브젝트
- [ ] 기출 3개년 1회독
- [ ] 기출 3개년 2회독 (오답 정리)
- [ ] 모의고사 3회 (80점 이상)
