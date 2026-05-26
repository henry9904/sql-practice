# 09. PIVOT · UNPIVOT (2024 개정 신규)

> **2024년 SQLD 개정으로 추가된 항목.** ★ = 시험 빈출

---

## 1. LONG DATA vs WIDE DATA

### LONG DATA (Tidy Data)
> 하나의 속성이 하나의 컬럼 → 값이 **아래로 길게** 쌓임

| 학생ID | 과목 | 점수 |
|---|---|---|
| 1 | 수학 | 90 |
| 1 | 과학 | 85 |
| 1 | 영어 | 88 |
| 2 | 수학 | 78 |

- RDBMS 표준 구조 → 조인 연산 용이
- 새로운 과목이 추가돼도 컬럼 변경 X

### WIDE DATA
> 여러 변수가 각각의 **열로 표현** → 가로로 펼쳐짐

| 학생ID | 수학 | 과학 | 영어 |
|---|---|---|---|
| 1 | 90 | 85 | 88 |
| 2 | 78 | 92 | 95 |

- 데이터 요약·보고에 적합
- 새 변수 추가 시 컬럼 추가 필요

### 변환

```
LONG → WIDE : PIVOT
WIDE → LONG : UNPIVOT
```

---

## 2. ★ PIVOT (행 → 열)

### 개요
- 교차표(Cross Tab)를 만드는 기능
- 데이터를 읽기 쉽고 분석하기 좋게 재구성
- LONG → WIDE 변환

### 핵심 구성 3가지

| 구성 | 역할 |
|---|---|
| **STACK** | 그룹핑 기준 (남는 컬럼) |
| **UNSTACK** | 열로 펼칠 컬럼 |
| **VALUE** | 셀에 들어갈 값 |

### 문법
```sql
SELECT *
FROM (SELECT STACK_컬럼, UNSTACK_컬럼, VALUE_컬럼 FROM 테이블)
PIVOT (
    집계함수(VALUE_컬럼)
    FOR UNSTACK_컬럼 IN ('값1', '값2', '값3')
);
```

### 예제: 판매원별 제품별 판매금액

**원본 (LONG)**
| SALESMAN | PRODUCT | AMOUNT |
|---|---|---|
| John | Laptop | 500 |
| John | Desktop | 600 |
| Jane | Laptop | 550 |
| Jane | Tablet | 150 |

```sql
SELECT *
FROM (SELECT SALESMAN, PRODUCT, AMOUNT FROM SALES)
PIVOT (
    SUM(AMOUNT)
    FOR PRODUCT IN ('Laptop', 'Desktop', 'Tablet')
);
```

**결과 (WIDE)**
| SALESMAN | 'Laptop' | 'Desktop' | 'Tablet' |
|---|---|---|---|
| John | 500 | 600 | NULL |
| Jane | 550 | NULL | 150 |

### ★ 주의사항
- 서브쿼리에서 **필요한 컬럼만** 선택해야 함  
  → 안 그러면 FROM의 모든 컬럼이 STACK으로 들어감 → 결과가 의도와 달라짐
- FOR 절의 값은 **따옴표로** 명시

---

## 3. ★ UNPIVOT (열 → 행)

### 개요
- PIVOT의 반대 — WIDE → LONG 변환
- 데이터를 정규화된 형태로 재구성

### 문법
```sql
SELECT *
FROM 테이블
UNPIVOT (
    새VALUE_컬럼명
    FOR 새컬럼명 IN (기존컬럼1, 기존컬럼2, ...)
);
```

### 예제: 월별 판매액

**원본 (WIDE)**
| PRODUCT | JANUARY | FEBRUARY | MARCH |
|---|---|---|---|
| Laptop | 1000 | 1200 | 1100 |
| Phone | 800 | 750 | 900 |

```sql
SELECT *
FROM SALES
UNPIVOT (
    SALES_AMOUNT
    FOR SALES_MONTH IN (JANUARY, FEBRUARY, MARCH)
);
```

**결과 (LONG)**
| PRODUCT | SALES_MONTH | SALES_AMOUNT |
|---|---|---|
| Laptop | JANUARY | 1000 |
| Laptop | FEBRUARY | 1200 |
| Laptop | MARCH | 1100 |
| Phone | JANUARY | 800 |
| ... | ... | ... |

### ★ 주의사항
- 새 컬럼명을 **두 개** 만들어줘야 함 (VALUE 컬럼명 + STACK 컬럼명)
- 기존 컬럼명이 **숫자**면 따옴표 필수: `"2024"` 등

---

## 시험 핵심 체크리스트

- [ ] LONG vs WIDE 차이 + 변환 방향
- [ ] PIVOT의 3가지 구성 요소 (STACK / UNSTACK / VALUE)
- [ ] PIVOT 서브쿼리에서 필요한 컬럼만 선택해야 함
- [ ] UNPIVOT은 컬럼명 2개 정의 필요
- [ ] 집계함수는 PIVOT, UNPIVOT 모두 적용
