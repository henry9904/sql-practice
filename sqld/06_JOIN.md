# 06. JOIN (2과목)

> ★ = 시험 빈출

---

## JOIN 개요

"두 개 이상의 테이블들을 연결/결합하여 데이터를 출력하는 것"

---

## EQUI JOIN (등가 조인)

```sql
-- 전통적 방식
SELECT P.PLAYER_NAME, T.TEAM_NAME
FROM PLAYER P, TEAM T
WHERE P.TEAM_ID = T.TEAM_ID;

-- ANSI 방식 (권장)
SELECT P.PLAYER_NAME, T.TEAM_NAME
FROM PLAYER P
INNER JOIN TEAM T ON P.TEAM_ID = T.TEAM_ID;
```

---

## 표준 JOIN (ANSI/ISO)

### ★ INNER JOIN
- JOIN 조건에서 **동일한 값이 있는 행만** 반환
- DEFAULT 옵션 (JOIN = INNER JOIN)
- USING 또는 ON 조건절 필수

```sql
SELECT EMP.DEPTNO, ENAME, DNAME
FROM EMP JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO;
```

### ★ NATURAL JOIN
- 동일한 이름의 모든 칼럼에 대해 자동으로 EQUI JOIN
- WHERE/USING/ON 조건절 사용 불가
- **ALIAS/테이블명 접두사 사용 불가**

```sql
SELECT DEPTNO, ENAME, DNAME
FROM EMP NATURAL JOIN DEPT;
```

### ★ USING 조건절
- 같은 이름 칼럼 중 원하는 것만 선택적으로 JOIN
- SQL Server 미지원
- JOIN 칼럼에 **ALIAS/테이블명 접두사 사용 불가**

```sql
SELECT * FROM DEPT JOIN DEPT_TEMP USING (DEPTNO);
```

### ★ ON 조건절
- 칼럼명이 달라도 JOIN 조건 사용 가능
- WHERE 절과 혼용 가능
- ★ **ALIAS/테이블명 접두사 반드시 사용해야 함**

```sql
SELECT E.ENAME, E.DEPTNO, D.DNAME
FROM EMP E JOIN DEPT D ON (E.DEPTNO = D.DEPTNO)
WHERE E.DEPTNO = 30;
```

### CROSS JOIN
- 조인 조건 없이 모든 조합 출력 (CARTESIAN PRODUCT)
- 결과 행 수 = 테이블1 행 수 × 테이블2 행 수

```sql
SELECT ENAME, DNAME FROM EMP CROSS JOIN DEPT;
```

### ★ OUTER JOIN
- 조인 조건에 맞지 않는 행도(NULL 포함) 출력

```sql
-- LEFT OUTER JOIN: 좌측 테이블 기준 전체 출력
SELECT S.STADIUM_NAME, T.TEAM_NAME
FROM STADIUM S LEFT OUTER JOIN TEAM T ON S.HOMETEAM_ID = T.TEAM_ID;

-- RIGHT OUTER JOIN: 우측 테이블 기준
-- FULL OUTER JOIN: 양쪽 모두 기준 (합집합)
```

---

## INNER vs OUTER vs CROSS 비교

| JOIN | 결과 |
|---|---|
| INNER JOIN | 양쪽 다 있는 것만 |
| LEFT OUTER | 좌측 전체 + 우측 매칭 (없으면 NULL) |
| RIGHT OUTER | 우측 전체 + 좌측 매칭 (없으면 NULL) |
| FULL OUTER | 양쪽 전체 (없으면 NULL) |
| CROSS JOIN | 모든 조합 (행수 곱) |

---

## 집합 연산자

| 연산자 | 의미 |
|---|---|
| `UNION` | 합집합 (중복 제거) |
| `UNION ALL` | 합집합 (중복 포함) |
| `INTERSECT` | 교집합 |
| `EXCEPT` / `MINUS` | 차집합 |

- SELECT절 칼럼 수가 동일해야 함
- 동일 위치 칼럼의 데이터타입이 호환 가능해야 함
