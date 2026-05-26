# 04. WHERE 절 & 함수

> **2과목 · SQL 기본**. ★ = 시험 빈출

---

## 1. WHERE 절

```sql
SELECT 칼럼 FROM 테이블 WHERE 조건식;
```

### ★ 연산자 우선순위 (암기)
```
1. 괄호 ( )
2. NOT
3. 비교 연산자  (=, >, >=, <, <=, <>, !=)
4. SQL 연산자   (BETWEEN, IN, LIKE, IS NULL)
5. AND
6. OR
```

---

## 2. 비교 연산자

| 연산자 | 의미 |
|---|---|
| `=` | 같다 |
| `<>`, `!=`, `^=` | 다르다 |
| `>`, `>=` | 크다, 크거나 같다 |
| `<`, `<=` | 작다, 작거나 같다 |

---

## 3. SQL 연산자

### IN (다중 값)
```sql
SELECT * FROM PLAYER WHERE TEAM_ID IN ('K01', 'K02', 'K03');

-- 다중 칼럼 IN
SELECT ENAME, JOB, DEPTNO FROM EMP
WHERE (JOB, DEPTNO) IN (('MANAGER', 20), ('CLERK', 30));
```

### LIKE (패턴 매칭)
| 와일드카드 | 의미 |
|---|---|
| `%` | **0개 이상**의 문자 |
| `_` | **정확히 1개** 문자 |

```sql
WHERE PLAYER_NAME LIKE '장%';     -- "장"으로 시작
WHERE PLAYER_NAME LIKE '%수';     -- "수"로 끝남
WHERE PLAYER_NAME LIKE '_지성';   -- 첫 글자 임의 + "지성"
WHERE PLAYER_NAME LIKE '%박%';    -- "박" 포함
```

### BETWEEN a AND b
```sql
-- a 이상 b 이하 (양쪽 포함)
WHERE HEIGHT BETWEEN 170 AND 180;
-- 동일: WHERE HEIGHT >= 170 AND HEIGHT <= 180
```

### IS NULL / IS NOT NULL
```sql
WHERE POSITION IS NULL;
WHERE POSITION IS NOT NULL;
```

### 부정 SQL 연산자
- `NOT BETWEEN ... AND ...`
- `NOT IN (...)`
- `IS NOT NULL`

---

## 4. ★ NULL 처리 규칙

| 연산 | 결과 |
|---|---|
| `NULL + 100` | **NULL** (수치연산 → NULL) |
| `NULL = 0` | **FALSE** (비교연산 → FALSE) |
| `NULL = NULL` | **FALSE/UNKNOWN** (같다고 판단 X) |
| `NULL IS NULL` | TRUE |
| `COUNT(*)` | NULL 포함 |
| `COUNT(칼럼)` | NULL 제외 |
| `SUM/AVG(NULL포함)` | NULL은 무시하고 계산 |

---

## 5. ROWNUM vs TOP

### Oracle: ROWNUM
> SQL 결과 집합의 각 행에 임시로 부여되는 일련번호 (Pseudo Column)

```sql
-- 첫 3건만
SELECT * FROM PLAYER WHERE ROWNUM <= 3;

-- 인덱스 부여
UPDATE MY_TABLE SET COLUMN1 = ROWNUM;
```

> ★ 주의: `WHERE ROWNUM = 5` 같은 형태는 작동 X (ROWNUM은 결과 행마다 매겨지므로)

### SQL Server: TOP
```sql
SELECT TOP(5) PLAYER_NAME FROM PLAYER;
SELECT TOP(10) PERCENT PLAYER_NAME FROM PLAYER;   -- 상위 10%
SELECT TOP(2) WITH TIES * FROM EMP ORDER BY SAL DESC;  -- 동률 포함
```

---

## 6. 함수 분류

| 분류 | 입출력 |
|---|---|
| **단일행 함수** | 1행 입력 → 1행 출력 |
| **다중행(집계) 함수** | N행 입력 → 1행 출력 (M:1) |

---

## 7. 문자형 함수

| 함수 (Oracle / SQL Server) | 설명 | 예시 |
|---|---|---|
| `LENGTH(s)` / `LEN(s)` | 길이 | `LENGTH('SQL')` → 3 |
| `SUBSTR(s,n,m)` / `SUBSTRING(s,n,m)` | n번째부터 m개 | `SUBSTR('SQLD',2,2)` → 'QL' |
| `UPPER(s)` / `LOWER(s)` | 대/소문자 | `UPPER('sql')` → 'SQL' |
| `LTRIM(s)`, `RTRIM(s)`, `TRIM(s)` | 공백 제거 | `TRIM(' SQL ')` → 'SQL' |
| `REPLACE(s,a,b)` | a→b 교체 | `REPLACE('SQL','S','M')` → 'MQL' |
| `CONCAT(s1,s2)` | 연결 | Oracle: `\|\|`, SQL: `+` |
| `INSTR(s,sub)` | 위치 반환 | `INSTR('SQLD','L')` → 3 |

---

## 8. 숫자형 함수

| 함수 | 설명 | 예시 |
|---|---|---|
| `ABS(n)` | 절댓값 | `ABS(-5)` → 5 |
| `ROUND(n,m)` | m자리 반올림 | `ROUND(1.234,2)` → 1.23 |
| `TRUNC(n,m)` | m자리 절사 | `TRUNC(1.234,2)` → 1.23 |
| `CEIL(n)` / `CEILING(n)` | 올림 | `CEIL(1.1)` → 2 |
| `FLOOR(n)` | 내림 | `FLOOR(1.9)` → 1 |
| `MOD(n,m)` | 나머지 | `MOD(10,3)` → 1 |
| `POWER(n,m)` | 거듭제곱 | `POWER(2,3)` → 8 |
| `SIGN(n)` | 부호 (-1, 0, 1) | `SIGN(-3)` → -1 |

---

## 9. 날짜형 함수

### Oracle
```sql
SELECT SYSDATE FROM DUAL;                       -- 현재 날짜+시간
SELECT EXTRACT(YEAR FROM HIREDATE) FROM EMP;    -- 연도 추출
SELECT EXTRACT(MONTH FROM HIREDATE) FROM EMP;
SELECT EXTRACT(DAY FROM HIREDATE) FROM EMP;
SELECT MONTHS_BETWEEN(SYSDATE, HIREDATE) FROM EMP;
SELECT ADD_MONTHS(HIREDATE, 6) FROM EMP;
```

### SQL Server
```sql
SELECT GETDATE();
SELECT YEAR(HIREDATE), MONTH(HIREDATE), DAY(HIREDATE) FROM EMP;
SELECT DATEPART(YEAR, HIREDATE) FROM EMP;
SELECT DATEADD(MONTH, 6, HIREDATE) FROM EMP;
SELECT DATEDIFF(DAY, HIREDATE, GETDATE()) FROM EMP;
```

---

## 10. ★ 변환 함수

### 묵시적 변환 vs 명시적 변환

| 종류 | 의미 |
|---|---|
| **묵시적 변환** | DBMS가 자동 변환 (예: `'100' + 1` → 101) |
| **명시적 변환** | 함수로 직접 변환 (`TO_NUMBER('100')`) |

> 실무에서는 **명시적 변환 권장** (성능, 가독성)

### Oracle 변환 함수

| 함수 | 설명 | 예시 |
|---|---|---|
| `TO_CHAR(n, fmt)` | 숫자/날짜 → 문자 | `TO_CHAR(1234, '999,999')` → '1,234' |
| `TO_NUMBER(s)` | 문자 → 숫자 | `TO_NUMBER('1234')` → 1234 |
| `TO_DATE(s, fmt)` | 문자 → 날짜 | `TO_DATE('20260822','YYYYMMDD')` |

```sql
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(1234567, '999,999,999') FROM DUAL;
SELECT TO_NUMBER('1,234', '999,999') FROM DUAL;
SELECT TO_DATE('20260822', 'YYYYMMDD') FROM DUAL;
```

### ANSI / SQL Server: CAST, CONVERT

```sql
SELECT CAST('123' AS INT);
SELECT CONVERT(VARCHAR, GETDATE(), 120);   -- '2026-08-22 10:30:00'
```

---

## 11. ★ CASE 표현

### Simple CASE
```sql
SELECT ENAME,
  CASE JOB
    WHEN 'MANAGER' THEN '관리자'
    WHEN 'CLERK'   THEN '사무직'
    ELSE '기타'
  END AS JOB_KOR
FROM EMP;
```

### Searched CASE (조건식 사용)
```sql
SELECT ENAME,
  CASE WHEN SAL >= 3000 THEN 'HIGH'
       WHEN SAL >= 1000 THEN 'MID'
       ELSE 'LOW'
  END AS SALARY_GRADE
FROM EMP;
```

---

## 12. DECODE 함수 (Oracle 전용)

> IF-THEN-ELSE를 한 줄로 — Oracle만 지원

```sql
DECODE(표현식, 조건1, 결과1, 조건2, 결과2, ..., 기본값)
```

```sql
SELECT ENAME,
       DECODE(JOB, 'MANAGER', '관리자',
                   'CLERK',   '사무직',
                              '기타') AS JOB_KOR
FROM EMP;
```

### ★ CASE vs DECODE 비교
| 항목 | CASE | DECODE |
|---|---|---|
| 표준 | ANSI 표준 | Oracle 전용 |
| 범위 비교 | 가능 (`WHEN A > 10`) | **불가능** (등호만) |
| 가독성 | 좋음 | 짧지만 가독성 ↓ |

---

## 13. ★ NULL 관련 함수

### NVL / ISNULL
```sql
-- NULL이면 대체값
SELECT NVL(COMM, 0) FROM EMP;             -- Oracle
SELECT ISNULL(COMM, 0) FROM EMP;          -- SQL Server
```

### NVL2 (Oracle)
```sql
-- NULL이면 expr3, NOT NULL이면 expr2
SELECT NVL2(COMM, COMM+SAL, SAL) FROM EMP;
```

### NULLIF
```sql
-- expr1 = expr2면 NULL, 다르면 expr1
SELECT NULLIF(MGR, 7698) FROM EMP;
```

### ★ COALESCE (가장 강력)
```sql
-- 인수 중 NULL 아닌 첫 번째 값
SELECT COALESCE(COMM, BONUS, SAL, 0) FROM EMP;
```

### NULL과 공집합 차이
| 구분 | 의미 |
|---|---|
| **NULL** | 알 수 없는 값 (Unknown) |
| **공집합** | 0건의 결과 (예: `WHERE 1=2`) |

---

## 시험 핵심 체크리스트

- [ ] 연산자 우선순위 6단계
- [ ] NULL의 수치/비교 연산 결과
- [ ] LIKE 와일드카드 `%`와 `_` 차이
- [ ] BETWEEN은 양쪽 경계 포함
- [ ] ROWNUM vs TOP
- [ ] 단일행 vs 다중행 함수
- [ ] TO_CHAR, TO_DATE, TO_NUMBER 형식
- [ ] CASE vs DECODE 차이
- [ ] NVL, NVL2, NULLIF, COALESCE 동작
- [ ] 묵시적/명시적 형변환
