# 05. GROUP BY / HAVING / ORDER BY (2과목)

> ★ = 시험 빈출

---

## GROUP BY / HAVING

```sql
SELECT 칼럼명 FROM 테이블명
WHERE 조건식
GROUP BY 칼럼명
HAVING 그룹조건식
ORDER BY 칼럼명;
```

### 집계 함수

| 함수 | 설명 |
|---|---|
| `COUNT(*)` | 전체 행 수 |
| `COUNT(칼럼)` | NULL 제외 행 수 |
| `SUM(칼럼)` | 합계 |
| `AVG(칼럼)` | 평균 |
| `MAX(칼럼)` | 최댓값 |
| `MIN(칼럼)` | 최솟값 |

```sql
-- 포지션별 평균키
SELECT POSITION, COUNT(*), MAX(HEIGHT), MIN(HEIGHT), ROUND(AVG(HEIGHT),2)
FROM PLAYER
GROUP BY POSITION;

-- HAVING: 그룹 조건 (WHERE와 다르게 집계함수 사용 가능)
SELECT POSITION, ROUND(AVG(HEIGHT),2)
FROM PLAYER
GROUP BY POSITION
HAVING AVG(HEIGHT) >= 180;
```

- NULL 처리: `NVL(SUM(SAL), 0)` — 전체 SUM이 NULL인 경우만 한 번 사용

---

## ★ SELECT 실행 순서

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
```

> 암기 필수! 시험 단골 출제

---

## ORDER BY

```sql
-- 기본: ASC(오름차순, 기본값)
SELECT PLAYER_NAME, POSITION, BACK_NO
FROM PLAYER
WHERE BACK_NO IS NOT NULL
ORDER BY PLAYER_NAME DESC;  -- DESC: 내림차순
```

- ORDER BY에 칼럼명 대신 **SELECT절 순서 번호** 또는 **ALIAS** 사용 가능
- Oracle: NULL을 가장 큰 값으로 처리 (오름차순 시 맨 마지막)
- SQL Server: NULL을 가장 작은 값으로 처리 (오름차순 시 맨 처음)
