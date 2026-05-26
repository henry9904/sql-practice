-- 프로그래머스 Lv.1 | 역순 정렬하기
-- [문제 내용] 
-- 동물 보호소에 들어온 모든 동물의 이름과 보호 시작일을 조회하는 SQL문을 작성해주세요.
-- 결과는 ANIMAL_ID 역순으로 보여주세요.

SELECT NAME, DATETIME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID DESC;
