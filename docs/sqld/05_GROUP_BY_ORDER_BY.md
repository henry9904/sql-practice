# 05. GROUP BY · HAVING · ORDER BY

> **2과목 · SQL 기본**. ★ = 시험 빈출 / SELECT 실행 순서 단골 출제

---

## 1. 집계 함수 (Aggregate Function)

> 여러 행의 그룹이 모여 그룹당 하나의 결과를 반환 (다중행 함수)

| 함수 | 설명 | NULL 처리 |
|---|---|---|
| `COUNT(*)` | 전체 행 수 | NULL 포함 |
| `COUNT(칼럼)` | 칼럼 값 개수 | **NULL 제외** |
| `COUNT(DISTINCT 칼럼)` | 중복 제거 개수 | NULL 제외 |
| `SUM(칼럼)` | 합계 | NULL 제외 |
| `AVG(칼럼)` | 평균 | NULL 제외 |
| `MAX(칼럼)` | 최댓값 | NULL 제외 |
| `MIN(칼럼)` | 최솟값 | NULL 제외 |
| `STDDEV(칼럼)` | 표준편차 | NULL 제외 |
| `VARIANCE(칼럼)` | 분산 | NULL 제외 |

> ★ 집계함수의 NULL 처리는 시험 단골 출제

---

## 2. GROUP BY

### 문법
```sql
SELECT [DISTINCT] 칼럼 [ALIAS]
FROM   테이블
[WHERE 조건]
[GROUP BY 칼럼]
[HAVING 그룹조건]
[ORDER BY 칼럼];
```

### 예제: 포지션별 평균 키
```sql
SELECT POSITION,
       COUNT(*)             AS 인원수,
       COUNT(HEIGHT)        AS 키대상,
       MAX(HEIGHT)          AS 최대키,
       MIN(HEIGHT)          AS 최소키,
       ROUND(AVG(HEIGHT),2) AS 평균키
FROM PLAYER
GROUP BY POSITION;
```

### GROUP BY 사용 규칙
1. SELECT 절에는 **집계함수 또는 GROUP BY 칼럼**만 사용 가능
2. GROUP BY 절에서는 ALIAS 사용 불가 (실행 순서 때문)

```sql
-- ❌ 오류 (POSITION이 GROUP BY 안에 없음)
SELECT POSITION, ENAME, AVG(HEIGHT) FROM PLAYER GROUP BY POSITION;

-- ✓ OK
SELECT POSITION, AVG(HEIGHT) FROM PLAYER GROUP BY POSITION;
```

---

## 3. HAVING

> 그룹화된 결과에 대한 **조건** (집계함수 사용 가능)

```sql
SELECT POSITION, ROUND(AVG(HEIGHT),2) 평균키
FROM PLAYER
GROUP BY POSITION
HAVING AVG(HEIGHT) >= 180;
```

### ★ WHERE vs HAVING

| 항목 | WHERE | HAVING |
|---|---|---|
| 적용 시점 | GROUP BY **전** | GROUP BY **후** |
| 대상 | 개별 행 | 그룹 |
| 집계함수 사용 | 불가 | **가능** |

---

## 4. ★ SELECT 실행 순서 (최빈출)

```
1. FROM       → 테이블 참조
2. WHERE      → 행 필터링
3. GROUP BY   → 그룹화
4. HAVING     → 그룹 필터링
5. SELECT     → 칼럼 선택/계산
6. ORDER BY   → 정렬
```

```mermaid
graph LR
    F[FROM] --> W[WHERE]
    W --> G[GROUP BY]
    G --> H[HAVING]
    H --> S[SELECT]
    S --> O[ORDER BY]
```

> **암기 노하우**: "From Where Group Having Select Order"

---

## 5. CASE 활용 — 월별 집계 패턴

> 1NF로 분리된 데이터를 다시 가로로 펼치는 기법 (Pivot)

```sql
-- 사원 입사 월별 인원 수 (가로로 펼치기)
SELECT
  COUNT(CASE WHEN EXTRACT(MONTH FROM HIREDATE) = 1 THEN 1 END) AS "1월",
  COUNT(CASE WHEN EXTRACT(MONTH FROM HIREDATE) = 2 THEN 1 END) AS "2월",
  COUNT(CASE WHEN EXTRACT(MONTH FROM HIREDATE) = 3 THEN 1 END) AS "3월",
  COUNT(*) AS 합계
FROM EMP;
```

> 모델링의 제1정규화로 인해 반복되는 칼럼을 다시 가로로 표시하는 패턴

---

## 6. 집계 함수와 NULL 처리 패턴

```sql
-- 0으로 표시하고 싶을 때
SELECT NVL(SUM(SAL), 0) FROM EMP WHERE 1=2;  -- 공집합

-- ❌ 전체 합계가 0이면 NVL 결과도 0
-- ✓ 공집합이면 SUM이 NULL → NVL이 0 반환
```

---

## 7. ORDER BY

### 문법
```sql
SELECT 칼럼 FROM 테이블 ORDER BY 칼럼 [ASC|DESC];
```

### 정렬 방향
- `ASC`: 오름차순 (default)
- `DESC`: 내림차순

### ★ 정렬 기준 표현 방식

```sql
-- 1. 칼럼명
SELECT ENAME, SAL FROM EMP ORDER BY SAL DESC;

-- 2. ALIAS
SELECT ENAME, SAL AS 급여 FROM EMP ORDER BY 급여 DESC;

-- 3. SELECT 칼럼 순서 번호
SELECT ENAME, SAL FROM EMP ORDER BY 2 DESC;   -- SAL 기준

-- 4. 여러 기준
SELECT * FROM EMP ORDER BY DEPTNO ASC, SAL DESC;
```

### ★ NULL 정렬 차이
| DBMS | 오름차순 시 NULL 위치 |
|---|---|
| Oracle | 마지막 (NULL = 가장 큰 값) |
| SQL Server | 처음 (NULL = 가장 작은 값) |

```sql
-- Oracle에서 NULL 처음으로 정렬
SELECT * FROM EMP ORDER BY MGR NULLS FIRST;
```

---

## 8. TOP-N 쿼리

### Oracle (ROWNUM + 인라인뷰)
```sql
SELECT *
FROM (SELECT ENAME, SAL FROM EMP ORDER BY SAL DESC)
WHERE ROWNUM <= 3;
```

> ★ `WHERE ROWNUM <= 3` 을 **밖에 두어야** 정렬 후 행 추출

### SQL Server (TOP)
```sql
-- 동률 포함
SELECT TOP(2) WITH TIES ENAME, SAL
FROM EMP
ORDER BY SAL DESC;
-- 결과: KING 5000 / SCOTT 3000 / FORD 3000  (동률 3000 모두 포함)
```

---

## 시험 핵심 체크리스트

- [ ] 집계 함수의 NULL 처리 (COUNT(*) 외에는 NULL 제외)
- [ ] WHERE vs HAVING 차이 (적용 시점, 집계함수 사용 가능 여부)
- [ ] **SELECT 실행 순서 6단계 암기**
- [ ] GROUP BY에서 ALIAS 사용 불가 (실행 순서 때문)
- [ ] CASE를 활용한 PIVOT 패턴
- [ ] ORDER BY의 다양한 표현 방식
- [ ] Oracle vs SQL Server NULL 정렬 차이
- [ ] TOP-N 쿼리 Oracle 패턴 (인라인뷰)
