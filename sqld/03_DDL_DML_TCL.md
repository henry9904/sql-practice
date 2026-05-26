# 03. DDL / DML / TCL (2과목)

> ★ = 시험 빈출 | 2과목 40문항 중 핵심

---

## SQL 분류

- **DML** (Data Manipulation Language): SELECT, INSERT, UPDATE, DELETE → NOT AUTO COMMIT
- **DDL** (Data Definition Language): CREATE, ALTER, DROP, RENAME → **AUTO COMMIT**
- **DCL** (Data Control Language): GRANT, REVOKE
- **TCL** (Transaction Control Language): COMMIT, ROLLBACK

---

## DDL

### CREATE TABLE
```sql
CREATE TABLE 테이블이름 (
  칼럼명1 DATATYPE [DEFAULT 형식],
  칼럼명2 DATATYPE [DEFAULT 형식],
  CONSTRAINT PK명 PRIMARY KEY (칼럼명),
  CONSTRAINT FK명 FOREIGN KEY (칼럼명) REFERENCES 참조테이블(칼럼명)
);
```

- ★ 제약조건(CONSTRAINT) 종류: **PRIMARY KEY, UNIQUE KEY, NOT NULL, CHECK, FOREIGN KEY**
- NULL: "아직 정의되지 않은 미지의 값" / "현재 데이터를 입력하지 못하는 경우"
- DEFAULT: 칼럼값 미입력 시 기본값 설정
- 테이블 복제 (`CREATE TABLE ~ AS SELECT ~`): **NOT NULL만** 새 테이블에 적용됨

### ALTER TABLE
```sql
ALTER TABLE 테이블이름 ADD 속성명 데이터타입;       -- 칼럼 추가
ALTER TABLE 테이블이름 DROP COLUMN 속성명;          -- 칼럼 삭제 (데이터 있어도 삭제, 한번에 1개)
ALTER TABLE 테이블이름 MODIFY 속성명 데이터타입;    -- 칼럼 변경
ALTER TABLE 테이블이름 RENAME COLUMN 이전명 TO 새이름;
ALTER TABLE 테이블이름 DROP CONSTRAINT 제약조건명;
ALTER TABLE 테이블이름 ADD CONSTRAINT 제약조건명 ...;
```

### DROP / TRUNCATE

| 명령 | 설명 |
|---|---|
| `DROP TABLE` | 테이블 전체 삭제, 구조+데이터 모두 제거, 복구 불가 |
| `TRUNCATE TABLE` | 데이터만 제거, 구조는 유지, 복구 불가 |
| `DELETE FROM` | 데이터 행 삭제, ROLLBACK 가능 |

---

## DML

```sql
-- INSERT
INSERT INTO 테이블명 (칼럼1, 칼럼2) VALUES (값1, 값2);

-- UPDATE
UPDATE 테이블명 SET 칼럼명 = 새값 WHERE 조건;

-- DELETE
DELETE FROM 테이블명 WHERE 조건;  -- 조건 없으면 전체 삭제

-- SELECT
SELECT DISTINCT 칼럼명 FROM 테이블명;   -- DISTINCT: 중복 제거
SELECT 칼럼명 AS 별명 FROM 테이블명;    -- AS: 별칭
SELECT * FROM 테이블명;                 -- *: 전체 칼럼
```

---

## TCL

- ★ 트랜잭션 정의: "데이터베이스의 논리적 연산 단위"
- ★ 트랜잭션 특성 (ACID): **원자성(Atomicity), 일관성(Consistency), 고립성(Isolation), 지속성(Durability)**

```sql
COMMIT;                    -- 변경사항 DB에 반영
ROLLBACK;                  -- 이전 상태로 되돌림
SAVEPOINT 포인트명;        -- 중간 저장점 설정
ROLLBACK TO 포인트명;      -- 해당 저장점까지만 롤백
```

- ★ Oracle: DML 수행 후 사용자가 직접 COMMIT/ROLLBACK 해야 함
- ★ SQL Server: 기본 AUTO COMMIT
