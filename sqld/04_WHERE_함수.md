# 04. WHERE절 & 함수 (2과목)

> ★ = 시험 빈출

---

## WHERE 절

```sql
SELECT 칼럼명 FROM 테이블명 WHERE 조건식;
```

### 연산자 우선순위

★ `( )` → `NOT` → `비교연산자(=,>,<,>=,<=)` → `SQL연산자` → `AND` → `OR`

### SQL 연산자

```sql
-- IN
WHERE (JOB, DEPTNO) IN (('MANAGER', 20), ('CLERK', 30));

-- LIKE (% : 0개 이상 문자, _ : 1개 문자)
WHERE PLAYER_NAME LIKE '장%';

-- BETWEEN
WHERE HEIGHT BETWEEN 170 AND 180;   -- 170 이상 180 이하

-- IS NULL / IS NOT NULL
WHERE POSITION IS NULL;
```

- ★ NULL과 수치연산 → NULL 리턴
- ★ NULL과 비교연산 → FALSE 리턴

### ROWNUM / TOP

```sql
-- Oracle: ROWNUM
SELECT PLAYER_NAME FROM PLAYER WHERE ROWNUM <= 3;

-- SQL Server: TOP
SELECT TOP(5) PLAYER_NAME FROM PLAYER;
SELECT TOP(2) WITH TIES ENAME, SAL FROM EMP ORDER BY SAL DESC;
```

---

## 함수

### 문자형 함수

| 함수 | 설명 |
|---|---|
| `LENGTH(s)` / `LEN(s)` | 문자열 길이 |
| `SUBSTR(s,n,m)` | n번째부터 m개 추출 |
| `UPPER(s)` / `LOWER(s)` | 대/소문자 변환 |
| `TRIM(s)` | 앞뒤 공백 제거 |
| `REPLACE(s,a,b)` | a를 b로 교체 |
| `CONCAT(s1,s2)` | 문자열 연결 (`\|\|` Oracle, `+` SQL Server) |

### 숫자형 함수

| 함수 | 설명 |
|---|---|
| `ROUND(n,m)` | m자리 반올림 |
| `TRUNC(n,m)` | m자리 버림 |
| `CEIL(n)` | 올림 |
| `FLOOR(n)` | 내림 |
| `MOD(n,m)` | n을 m으로 나눈 나머지 |
| `ABS(n)` | 절댓값 |

### 날짜형 함수

```sql
-- Oracle
EXTRACT(YEAR FROM HIREDATE)
EXTRACT(MONTH FROM HIREDATE)

-- SQL Server
DATEPART(YEAR, HIREDATE)
YEAR(HIREDATE), MONTH(HIREDATE), DAY(HIREDATE)
```

### CASE 표현

```sql
SELECT ENAME,
  CASE WHEN SAL >= 3000 THEN 'HIGH'
       WHEN SAL >= 1000 THEN 'MID'
       ELSE 'LOW'
  END AS SALARY_GRADE
FROM EMP;
```

### NULL 관련 함수

```sql
-- NVL(Oracle) / ISNULL(SQL Server): NULL이면 대체값 반환
SELECT NVL(COMM, 0) FROM EMP;

-- NULLIF(expr1, expr2): 같으면 NULL, 다르면 expr1
SELECT NULLIF(MGR, 7698) FROM EMP;

-- ★ COALESCE(expr1, expr2, ...): NULL 아닌 첫 번째 값 반환
SELECT COALESCE(COMM, SAL) FROM EMP;
```
