-- 프로그래머스 Lv.1 | 아픈 동물 찾기
-- [문제 내용]
-- 동물 보호소에 들어온 동물 중 아픈 동물(INTAKE_CONDITION 이 'Sick' 인 경우)의 아이디와 이름을 조회하는 SQL 문을 작성해주세요.
-- 결과는 아이디(ANIMAL_ID) 순으로 조회해주세요.

SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE INTAKE_CONDITION = 'Sick'
ORDER BY ANIMAL_ID;
