# 03. DDL · DML · TCL

> **2과목 · SQL 기본**. ★ = 시험 빈출

---

## 1. SQL 분류

| 분류 | 명령어 | 특징 |
|---|---|---|
| **DDL** (Data Definition) | CREATE, ALTER, DROP, RENAME, TRUNCATE | **AUTO COMMIT** |
| **DML** (Data Manipulation) | SELECT, INSERT, UPDATE, DELETE | NOT AUTO COMMIT (Oracle) |
| **DCL** (Data Control) | GRANT, REVOKE | — |
| **TCL** (Transaction Control) | COMMIT, ROLLBACK, SAVEPOINT | — |

---

## 2. 데이터 유형

| 유형 | 설명 |
|---|---|
| `CHAR(n)` | **고정 길이 문자열** (남는 공간은 공백) |
| `VARCHAR2(n)` (Oracle) / `VARCHAR(n)` | 가변 길이 문자열 |
| `NUMBER(p,s)` | 숫자 (p=전체자리, s=소수자리) |
| `NUMERIC` | ANSI 표준 숫자 |
| `DATE` | 날짜 (Oracle: 초 단위까지) |
| `TIMESTAMP` | 날짜 + 시간 |
| `CLOB` / `BLOB` | 대용량 문자 / 이진 |

> CHAR vs VARCHAR2: `CHAR(5)`에 'AB'를 저장하면 'AB   '(공백 포함)으로 저장됨

---

## 3. DDL

### CREATE TABLE
```sql
CREATE TABLE PLAYER (
    PLAYER_ID    CHAR(7)      NOT NULL,
    PLAYER_NAME  VARCHAR2(20) NOT NULL,
    TEAM_ID      CHAR(3)      NOT NULL,
    POSITION     VARCHAR2(10) DEFAULT 'MF',
    HEIGHT       NUMBER(3),
    WEIGHT       NUMBER(3),
    CONSTRAINT PLAYER_PK PRIMARY KEY (PLAYER_ID),
    CONSTRAINT PLAYER_FK FOREIGN KEY (TEAM_ID) REFERENCES TEAM(TEAM_ID)
);
```

### ★ 제약조건 (CONSTRAINT) 5종류

| 제약조건 | 설명 |
|---|---|
| `PRIMARY KEY` | 기본키 (NOT NULL + UNIQUE) |
| `UNIQUE KEY` | 유일값, NULL 허용 |
| `NOT NULL` | NULL 금지 |
| `CHECK` | 조건 만족 (예: `CHECK (AGE >= 0)`) |
| `FOREIGN KEY` | 외래키 |

### NULL과 DEFAULT
- **NULL**: "아직 정의되지 않은 미지의 값"
- **DEFAULT**: 값 미입력 시 기본값 설정

### 테이블 구조 확인
```sql
DESCRIBE 테이블명;        -- Oracle
sp_help 'dbo.테이블명';   -- SQL Server
```

### CREATE AS SELECT (복제)
```sql
CREATE TABLE EMP_COPY AS SELECT * FROM EMP;
-- ★ 주의: NOT NULL 제약조건만 복제됨!
-- PK, FK, UNIQUE, CHECK는 복제 X
```

### ALTER TABLE
```sql
-- 칼럼 추가
ALTER TABLE PLAYER ADD ADDRESS VARCHAR2(80);

-- 칼럼 삭제 (한 번에 하나, 데이터 있어도 삭제 가능)
ALTER TABLE PLAYER DROP COLUMN ADDRESS;

-- 칼럼 데이터타입 변경
ALTER TABLE PLAYER MODIFY POSITION VARCHAR2(20);
-- ALTER TABLE PLAYER ALTER COLUMN POSITION VARCHAR(20);  -- SQL Server

-- 칼럼명 변경
ALTER TABLE PLAYER RENAME COLUMN PLAYER_ID TO ID;

-- 테이블명 변경
RENAME PLAYER TO PLAYER_NEW;          -- Oracle
sp_rename 'PLAYER', 'PLAYER_NEW';     -- SQL Server

-- 제약조건 추가/삭제
ALTER TABLE PLAYER ADD CONSTRAINT PK_PLAYER PRIMARY KEY (PLAYER_ID);
ALTER TABLE PLAYER DROP CONSTRAINT PK_PLAYER;
```

### ★ DROP vs TRUNCATE vs DELETE 비교

| 명령 | 분류 | 구조 | 데이터 | ROLLBACK | 속도 |
|---|---|---|---|---|---|
| `DROP TABLE` | DDL | **삭제** | 삭제 | 불가 | 빠름 |
| `TRUNCATE TABLE` | DDL | 유지 | 삭제 | 불가 | 빠름 |
| `DELETE FROM` | DML | 유지 | 삭제 | **가능** | 느림 |

```sql
DROP TABLE PLAYER;                        -- 테이블 자체 삭제
DROP TABLE PLAYER CASCADE CONSTRAINTS;    -- FK 참조 제약 함께 삭제

TRUNCATE TABLE PLAYER;                    -- 데이터만 삭제, 구조 유지

DELETE FROM PLAYER WHERE TEAM_ID = 'K01'; -- 조건 가능, ROLLBACK 가능
```

---

## 4. DML

### INSERT
```sql
-- 칼럼 지정
INSERT INTO PLAYER (PLAYER_ID, PLAYER_NAME, TEAM_ID)
VALUES ('2002007', '박지성', 'K07');

-- 전체 칼럼 (순서 일치 필수)
INSERT INTO PLAYER VALUES ('2002007', '박지성', 'K07', ...);

-- SELECT 결과 삽입
INSERT INTO PLAYER_BACKUP SELECT * FROM PLAYER WHERE TEAM_ID = 'K07';
```

### UPDATE
```sql
UPDATE PLAYER SET BACK_NO = 99 WHERE PLAYER_ID = '2002007';
UPDATE PLAYER SET POSITION = 'MF';   -- WHERE 없으면 전체 수정
```

### DELETE
```sql
DELETE FROM PLAYER WHERE TEAM_ID = 'K07';
DELETE FROM PLAYER;   -- 조건 없으면 전체 삭제
```

### SELECT
```sql
SELECT 칼럼 FROM 테이블;
SELECT DISTINCT POSITION FROM PLAYER;        -- 중복 제거
SELECT * FROM PLAYER;                        -- 전체 칼럼
SELECT PLAYER_NAME AS 이름 FROM PLAYER;      -- 별칭
SELECT PLAYER_NAME "선수 이름" FROM PLAYER;  -- 공백 포함 별칭
```

### ★ 산술 / 합성 연산자
```sql
-- 산술
SELECT PLAYER_NAME, HEIGHT - WEIGHT "키-몸무게" FROM PLAYER;

-- 합성 (Oracle: ||)
SELECT PLAYER_NAME || '선수, ' || HEIGHT || 'cm' AS 정보 FROM PLAYER;

-- 합성 (SQL Server: +)
SELECT PLAYER_NAME + '선수, ' + HEIGHT + 'cm' AS 정보 FROM PLAYER;
```

---

## 5. ★ MERGE (Oracle)

> "INSERT + UPDATE + DELETE를 한 번에" — 조건에 따라 분기

### 기본 구조
```sql
MERGE INTO 대상테이블 T
USING 소스테이블 S
ON (T.키 = S.키)
WHEN MATCHED THEN
    UPDATE SET ...
    [DELETE WHERE 조건]
WHEN NOT MATCHED THEN
    INSERT (칼럼...) VALUES (값...);
```

### 예시
```sql
MERGE INTO STUDENT T
USING STUDENT_TMP S
ON (T.ID = S.ID)
WHEN MATCHED THEN
    UPDATE SET T.NAME = S.NAME
    DELETE WHERE S.STATUS = 'D'         -- 매칭된 행 중 추가 조건 만족 시 삭제
WHEN NOT MATCHED THEN
    INSERT (ID, NAME) VALUES (S.ID, S.NAME);
```

- 매칭: UPDATE → 추가 조건 만족 시 DELETE
- 비매칭: INSERT

---

## 6. ★ TCL (Transaction Control)

### 트랜잭션 정의
> "데이터베이스의 **논리적 연산 단위**"

- 분할할 수 없는 최소 단위
- All or Nothing
- 한 트랜잭션 = 1개 이상의 SQL

### ★ 트랜잭션 4가지 특성 (ACID)

| 특성 | 의미 |
|---|---|
| **원자성 (Atomicity)** | 전부 적용하거나 전부 취소 |
| **일관성 (Consistency)** | 트랜잭션 전후 데이터 일관성 유지 |
| **고립성 (Isolation)** | 트랜잭션 중간 결과는 다른 트랜잭션에 보이지 않음 |
| **지속성 (Durability)** | 완료된 트랜잭션은 영구 반영 |

### COMMIT
```sql
UPDATE PLAYER SET HEIGHT = 100;
COMMIT;   -- 변경사항 DB에 영구 반영
```

### ROLLBACK
```sql
UPDATE PLAYER SET HEIGHT = 100;
ROLLBACK;   -- 이전 COMMIT 시점으로 되돌림
```

### SAVEPOINT
```sql
INSERT INTO PLAYER VALUES (...);
SAVEPOINT SVPT1;
UPDATE PLAYER SET HEIGHT = 100;
SAVEPOINT SVPT2;
DELETE FROM PLAYER;
ROLLBACK TO SVPT1;   -- SVPT1 시점까지만 롤백
COMMIT;
```

### ★ Oracle vs SQL Server 비교

| 항목 | Oracle | SQL Server |
|---|---|---|
| DML 후 COMMIT | **수동 (사용자가 COMMIT)** | **AUTO COMMIT** |
| 트랜잭션 시작 | 자동 (SQL 실행 시) | `BEGIN TRAN` |

```sql
-- SQL Server에서 수동 트랜잭션 시작
BEGIN TRAN
UPDATE PLAYER SET HEIGHT = 100;
ROLLBACK;
```

---

## 7. ★★ 트랜잭션 격리성 (Isolation) — 출제 단골

### 고립성(Isolation)이 낮을 때 발생 문제

| 현상 | 설명 |
|---|---|
| **Dirty Read** | 다른 트랜잭션이 **수정 중 (커밋 X) 데이터**를 읽음 |
| **Non-Repeatable Read** | 같은 쿼리를 두 번 했는데 **사이에 수정/삭제** 되어 결과가 다름 |
| **Phantom Read** | 같은 쿼리를 두 번 했는데 **사이에 추가**되어 새 행이 나타남 |

### 격리 수준 (Isolation Level)

| 레벨 | Dirty Read | Non-Repeatable | Phantom |
|---|---|---|---|
| READ UNCOMMITTED | 발생 | 발생 | 발생 |
| READ COMMITTED (기본) | X | 발생 | 발생 |
| REPEATABLE READ | X | X | 발생 |
| SERIALIZABLE | X | X | X |

---

## 8. ★ 데이터 무결성 (Integrity)

| 무결성 | 설명 |
|---|---|
| **개체 무결성** | PK가 NULL 아니고 중복 없음 |
| **참조 무결성** | FK는 부모 테이블 PK 또는 NULL |
| **도메인 무결성** | 각 속성 값이 도메인(타입·범위) 내 |
| **NULL 무결성** | NOT NULL 컬럼에 NULL 불가 |
| **고유 무결성** | UNIQUE 컬럼 값 중복 불가 |
| **키 무결성** | 한 릴레이션에 적어도 하나의 키 존재 |

---

## 9. ★ 제약조건 자세히

### PRIMARY KEY (기본키)
- 유일성 + NOT NULL
- 한 테이블에 **하나만**
- 자동으로 UNIQUE INDEX 생성
- CREATE AS SELECT 시 **복제 X**

```sql
-- 단일 컬럼 PK
CREATE TABLE EMP (
    EMPNO NUMBER PRIMARY KEY,
    ...
);

-- 복합 PK
CREATE TABLE ORDER_DETAIL (
    ORDER_ID NUMBER,
    PRODUCT_ID NUMBER,
    QUANTITY NUMBER,
    CONSTRAINT PK_ORDER_DETAIL PRIMARY KEY (ORDER_ID, PRODUCT_ID)
);

-- 기존 테이블에 PK 추가
ALTER TABLE EMP ADD CONSTRAINT PK_EMP PRIMARY KEY (EMPNO);

-- PK 삭제 (자동 인덱스도 삭제됨)
ALTER TABLE EMP DROP CONSTRAINT PK_EMP;
```

### UNIQUE
- 중복 불가, **NULL은 중복 허용**
- 한 테이블에 **여러 개** 가능
- 자동 인덱스 생성

```sql
CREATE TABLE USERS (
    EMAIL VARCHAR2(100) UNIQUE,
    CONSTRAINT UK_NAME_PHONE UNIQUE (NAME, PHONE)  -- 복합 UNIQUE
);
```

### NOT NULL
- NULL 값 금지
- ★ ALTER 시 `ADD`가 아닌 `MODIFY` 사용

```sql
ALTER TABLE EMP MODIFY ENAME NOT NULL;
```

### ★ FOREIGN KEY (외래키)
- 부모 테이블의 PK 또는 UNIQUE 참조
- 참조 무결성 보장

```sql
CREATE TABLE EMP (
    EMPNO NUMBER PRIMARY KEY,
    DEPT_ID NUMBER,
    CONSTRAINT FK_EMP_DEPT FOREIGN KEY (DEPT_ID)
        REFERENCES DEPT(DEPT_ID)
);
```

### ★ FK 옵션 (부모 행 삭제 시 동작)

| 옵션 | 동작 |
|---|---|
| (옵션 없음) | 자식이 참조 중이면 부모 삭제 **불가** (기본) |
| `ON DELETE CASCADE` | 부모 삭제 시 **자식도 자동 삭제** |
| `ON DELETE SET NULL` | 부모 삭제 시 자식 FK를 **NULL로 설정** |

```sql
CONSTRAINT FK_EMP_DEPT FOREIGN KEY (DEPT_ID)
    REFERENCES DEPT(DEPT_ID) ON DELETE CASCADE
```

### CHECK
- 컬럼 값이 특정 조건 만족하도록 강제

```sql
CREATE TABLE EMP (
    SALARY NUMBER CHECK (SALARY >= 0),
    AGE NUMBER CHECK (AGE BETWEEN 0 AND 150)
);
```

---

## 시험 핵심 체크리스트

- [ ] DML/DDL/DCL/TCL 명령어 분류
- [ ] DDL이 AUTO COMMIT인 것
- [ ] DROP vs TRUNCATE vs DELETE 차이
- [ ] CREATE AS SELECT 시 복제되는 제약조건은 NOT NULL뿐
- [ ] 제약조건 5종류
- [ ] ACID 4가지 특성 (원자성·일관성·고립성·지속성)
- [ ] SAVEPOINT 동작 방식
- [ ] Oracle vs SQL Server COMMIT 차이
- [ ] CHAR vs VARCHAR2 차이
- [ ] **★ 격리성 이슈 3가지 (Dirty Read / Non-Repeatable / Phantom)**
- [ ] 격리 수준 4가지와 발생 가능 현상
- [ ] 6가지 데이터 무결성 (개체·참조·도메인·NULL·고유·키)
- [ ] UNIQUE는 NULL 중복 허용
- [ ] **★ FK 옵션 (ON DELETE CASCADE / SET NULL)**
- [ ] MERGE의 MATCHED / NOT MATCHED 분기
