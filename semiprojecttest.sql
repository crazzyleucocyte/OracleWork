create table test(
    content1 varchar2(50),
content2 varchar2(50),
content3 varchar2(50)
);

set serveroutput on;

insert into test values('test1','test2', 'test3');
commit;
create sequence test_seq;

alter table test add id number;

DECLARE
    CURSOR c IS SELECT rowid FROM test; -- 테이블의 각 행을 참조하는 커서
    r c%ROWTYPE; -- 커서의 행을 저장할 변수
BEGIN
    OPEN c; -- 커서 열기
    LOOP
        FETCH c INTO r; -- 커서로부터 행을 가져오기
        EXIT WHEN c%NOTFOUND; -- 더 이상 행이 없으면 종료

        -- 각 행에 sequence 값을 할당
        UPDATE test
        SET id = test_seq.NEXTVAL
        WHERE rowid = r.rowid;
        
        -- 각 업데이트마다 커밋
        
    END LOOP;
    CLOSE c; -- 커서 닫기
END;
/
DECLARE
    CURSOR c IS SELECT rowid FROM WALKING_TRAIL; -- 테이블의 각 행을 참조하는 커서
    r c%ROWTYPE; -- 커서의 행을 저장할 변수
BEGIN
    OPEN c; -- 커서 열기
    LOOP
        FETCH c INTO r; -- 커서로부터 행을 가져오기
        EXIT WHEN c%NOTFOUND; -- 더 이상 행이 없으면 종료

        -- 각 행에 sequence 값을 할당
        UPDATE WALKING_TRAIL
        SET WLK_MODIFIED_DT = ''
        WHERE rowid = r.rowid;
        
        -- 각 업데이트마다 커밋
        
    END LOOP;
    CLOSE c; -- 커서 닫기
END;
/
UPDATE CULTURE_FCLT
        SET FCLTY_MODIFIED_DT = ''
        WHERE c_id = 200001;
commit;

CREATE TABLE CULTURE_FCLT (

	FCLTY_NM	VARCHAR2(200)	NOT NULL,
	CTGRY_ONE_NM	VARCHAR2(200)	NOT NULL,
	CTGRY_TWO_NM	VARCHAR2(200)	NOT NULL,
	CTGRY_THREE_NM	VARCHAR2(200),
    CTPRVN_NM VARCHAR2(200),
	SIGNGU_NM	VARCHAR2(200),
	LEGALDONG_NM	VARCHAR2(200),
	LI_NM	VARCHAR2(200)	,
	LNBR_NO	VARCHAR2(20)	,
	ROAD_NM	VARCHAR2(200)	,
	BULD_NO	VARCHAR2(20)	,
	LC_LA	VARCHAR2(20)	NOT NULL,
	LC_LO	VARCHAR2(20)	NOT NULL,
	ZIP_NO	VARCHAR(5),
	RDNMADR_NM	VARCHAR2(200),
	LNM_ADDR	VARCHAR2(200),
	TEL_NO	VARCHAR2(20),
	HMPG_URL	VARCHAR2(500),
	RSTDE_GUID_CN	VARCHAR2(500),
	OPER_TIME	VARCHAR2(500),
	PARKING_POSBL_AT	VARCHAR(1)	NOT NULL,
	UTILIIZA_PRC_CN	VARCHAR2(1000)	NOT NULL,
	PET_POSBL_AT	VARCHAR(1)	NOT NULL,
	PET_INFO_CN	VARCHAR2(500)	NOT NULL,
	ENTRN_POSBL_PET_SIZE_VALUE	VARCHAR2(200),
	PET_LMTT_MTR_CN	VARCHAR2(4000),
	IN_PLACE_ACP_POSBL_AT	VARCHAR(1)	NOT NULL,
	OUT_PLACE_ACP_POSBL_AT	VARCHAR(1)	NOT NULL,
	FCLTY_INFO_DC	VARCHAR2(4000)	NOT NULL,
	PET_ACP_ADIT_CHRGE_VALUE	VARCHAR2(200)	NOT NULL,
	LAST_UPDT_DE	VARCHAR(8)	NOT NULL,
	FIRST_CRT_DT	DATE
);

select * from v$version;
select length(ENTRN_POSBL_PET_SIZE_VALUE) from culture_fclt
order by length(ENTRN_POSBL_PET_SIZE_VALUE);

CREATE TABLE WALKING_TRAIL ( 
  W_ID VARCHAR2(26),
  WLKTRL_NM VARCHAR2(200),
  COURS_NM VARCHAR2(200),
  COURS_DC VARCHAR2(4000),
  CTPRVN_NM VARCHAR2(200),
  SIGNGU_NM VARCHAR2(200),
  COURS_LV_NM VARCHAR2(200),
  COURS_CN VARCHAR2(500),
  COURS_DT_CN VARCHAR2(500),
  ADIT_DC VARCHAR2(4000),
  COURS_TM_CN VARCHAR2(500),
  OPTN_DC VARCHAR2(500),
  TOILET_DC VARCHAR2(500),
  CNVN_DC VARCHAR2(500),
  LNM_ADDR VARCHAR2(200),
  LC_LA NUMBER(38, 7),
  LC_LO NUMBER(38, 7),
  SIGNGU_NM2 VARCHAR2(200),
  CTPRVN_NM2 VARCHAR2(200));
  
  DECLARE
    CURSOR c IS SELECT SIGNGU_NM2 FROM WALKING_TRAIL; -- 테이블의 각 행을 참조하는 커서
    r c%ROWTYPE; -- 커서의 행을 저장할 변수
BEGIN
    
    LOOP
        FETCH c INTO r; -- 커서로부터 행을 가져오기
        EXIT WHEN c%NOTFOUND; -- 더 이상 행이 없으면 종료
        
        -- 각 행에 sequence 값을 할당
        IF INSTR(r.SIGNGU_NM2, ' ') > 0
        then UPDATE WALKING_TRAIL
            SET 
        SIGNGU_NM2 = SUBSTR(SIGNGU_NM2, 1, INSTR(SIGNGU_NM2, ' ') - 1)
            where WLK_COURS_FLAG_NM= '고양누리길';
        end if;
        -- 각 업데이트마다 커밋
        
    END LOOP;
    CLOSE c; -- 커서 닫기
END;
/
ALTER TABLE WALKING_TRAIL ADD CTPRVN_NM2 VARCHAR2(50);
ALTER TABLE WALKING_TRAIL ADD SIGNGU_NM2 VARCHAR2(100);

UPDATE WALKING_TRAIL
SET 
    CTPRVN_NM = SUBSTR(SIGNGU_NM, 1, INSTR(SIGNGU_NM, ' ') - 1),
    SIGNGU_NM2 = SUBSTR(SIGNGU_NM, INSTR(SIGNGU_NM, ' ') + 1);

UPDATE WALKING_TRAIL
SET 
   SIGNGU_NM2 = SUBSTR(SIGNGU_NM2, 1, INSTR(SIGNGU_NM2, ' ') - 1)
   where WLK_COURS_FLAG_NM= '온천과 함께하는 솔바람길';
   
   DECLARE
    CURSOR c IS SELECT SIGNGU_NM2 into signgunm FROM test; -- 테이블의 각 행을 참조하는 커서
    r c%ROWTYPE; -- 커서의 행을 저장할 변수
BEGIN
    OPEN c; -- 커서 열기
    LOOP
        FETCH c INTO r; -- 커서로부터 행을 가져오기
        EXIT WHEN c%NOTFOUND; -- 더 이상 행이 없으면 종료
        
        -- 각 행에 sequence 값을 할당
        IF INSTR(r.signgunm, ' ') > 0 THEN
            UPDATE WALKING_TRAIL
            SET SIGNGU_NM2 = SUBSTR(r.signgunm, 1, INSTR(r.SIGNGU_NM2, ' ') - 1)
            WHERE WLK_COURS_FLAG_NM = '용인너울길'
            AND SIGNGU_NM2 = r.SIGNGU_NM2; -- 커서에서 가져온 값과 일치하는지 확인
            COMMIT; -- 각 업데이트마다 커밋
        END IF;
    END LOOP;
    CLOSE c; -- 커서 닫기
END;
/
   
   DECLARE
  v_table_name VARCHAR2(100) := 'WALKING_TRAIL'; -- 테이블 이름을 입력하세요.
  v_column_name VARCHAR2(100) := 'SIGNGU_NM2'; -- 컬럼 이름을 입력하세요.
  v_count INTEGER := 0;
BEGIN
  -- 띄어쓰기가 포함된 값을 검색합니다.
  EXECUTE IMMEDIATE 'SELECT  SIGNGU_NM2
                     FROM ' || v_table_name || ' 
                     WHERE INSTR(' || v_column_name || ', '' '') > 0' 
  INTO v_count;

  IF v_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Column "' || v_column_name || '" has ' || v_count || ' records with spaces.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No records with spaces found in column "' || v_column_name || '".');
  END IF;
END;
/


   DECLARE
  v_table_name VARCHAR2(100) := 'WALKING_TRAIL'; -- 테이블 이름을 입력하세요.
  v_column_name VARCHAR2(100) := 'SIGNGU_NM2'; -- 컬럼 이름을 입력하세요.
  v_update_count INTEGER := 0;
BEGIN
  -- 띄어쓰기가 포함된 값을 업데이트하는 구문 실행
  EXECUTE IMMEDIATE 'UPDATE ' || v_table_name || 
                    ' SET ' || v_column_name || ' = '|| SUBSTR(v_column_name, 1, INSTR(v_column_name, ' ') - 1) ||
                    ' WHERE INSTR(' || v_column_name || ', '' '') > 0' 
                    RETURNING COUNT(*) INTO v_update_count;

  IF v_update_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Updated ' || v_update_count || ' records with spaces in column "' || v_column_name || '".');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No records with spaces found in column "' || v_column_name || '".');
  END IF;
END;
/

DECLARE
  v_table_name VARCHAR2(100) := 'WALKING_TRAIL'; -- 테이블 이름을 입력하세요.
  v_column_name VARCHAR2(100) := 'SIGNGU_NM2'; -- 컬럼 이름을 입력하세요.
  v_update_count INTEGER := 0;
BEGIN
  -- 띄어쓰기가 포함된 값을 업데이트하는 구문 실행
  EXECUTE IMMEDIATE 
    'UPDATE ' || v_table_name || 
    ' SET ' || v_column_name || ' = SUBSTR(' || v_column_name || ', 1, INSTR(' || v_column_name || ', '' '') - 1) ' ||
    'WHERE INSTR(' || v_column_name || ', '' '') > 0'
    RETURNING COUNT(*) INTO v_update_count;

  IF v_update_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Updated ' || v_update_count || ' records with spaces in column "' || v_column_name || '".');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No records with spaces found in column "' || v_column_name || '".');
  END IF;
END;
/
DECLARE
  v_table_name VARCHAR2(100) := 'WALKING_TRAIL'; -- 테이블 이름을 입력하세요.
  v_column_name VARCHAR2(100) := 'SIGNGU_NM2'; -- 컬럼 이름을 입력하세요.
  v_sql_stmt VARCHAR2(1000);
  v_update_count INTEGER := 0;
BEGIN
  -- 동적 SQL문 생성
  v_sql_stmt := 'UPDATE ' || v_table_name || 
                ' SET ' || v_column_name || ' = SUBSTR(' || v_column_name || ', 1, INSTR(' || v_column_name || ', '' '') - 1) ' ||
                'WHERE INSTR(' || v_column_name || ', '' '') > 0';

  -- SQL문 실행
  EXECUTE IMMEDIATE v_sql_stmt;

  -- 업데이트된 행 수 확인
  v_update_count := SQL%ROWCOUNT;

  IF v_update_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Updated ' || v_update_count || ' records with spaces in column "' || v_column_name || '".');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No records with spaces found in column "' || v_column_name || '".');
  END IF;
END;
/

DECLARE
  v_update_count INTEGER := 0;
BEGIN
  -- 컬럼 값에 따라 업데이트하는 구문 실행
  UPDATE WALKING_TRAIL
  SET CTPRVN_NM = CASE
    WHEN CTPRVN_NM = '강원' THEN '강원도'
    WHEN CTPRVN_NM = '경기' THEN '경기도'
    WHEN CTPRVN_NM = '경남' THEN '경상남도'
    WHEN CTPRVN_NM = '경북' THEN '경상북도'
    WHEN CTPRVN_NM = '광주' THEN '광주광역시'
    WHEN CTPRVN_NM = '대구' THEN '대구광역시'
    WHEN CTPRVN_NM = '대전' THEN '대전광역시'
    WHEN CTPRVN_NM = '부산' THEN '부산광역시'
    WHEN CTPRVN_NM = '서울' THEN '서울특별시'
    WHEN CTPRVN_NM = '세종' THEN '세종특별자치시'
    WHEN CTPRVN_NM = '울산' THEN '울산광역시'
    WHEN CTPRVN_NM = '인천' THEN '인천광역시'
    WHEN CTPRVN_NM = '전남' THEN '전라남도'
    WHEN CTPRVN_NM = '전북' THEN '전라북도'
    WHEN CTPRVN_NM = '제주' THEN '제주특별자치도'
    WHEN CTPRVN_NM = '충남' THEN '충청남도'
    WHEN CTPRVN_NM = '충북' THEN '충청북도'
    ELSE CTPRVN_NM -- 다른 값은 그대로 유지
  END;

  -- 업데이트된 행 수 확인
  v_update_count := SQL%ROWCOUNT;

  IF v_update_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Updated ' || v_update_count || ' records with modified values in column "YOUR_COLUMN_NAME".');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No records found to update in column "YOUR_COLUMN_NAME".');
  END IF;
END;
/
delete from walking_trail where lnm_addr = '0';

ALTER TABLE walking_trail MODIFY COL_C INVISIBLE;
ALTER TABLE walking_trail MODIFY COL_D INVISIBLE;


ALTER TABLE walking_trail MODIFY ADIT_DC VISIBLE;
ALTER TABLE walking_trail MODIFY CNVN_DC VISIBLE;
ALTER TABLE walking_trail MODIFY COURS_CN VISIBLE;
ALTER TABLE walking_trail MODIFY COURS_DC VISIBLE;
ALTER TABLE walking_trail MODIFY COURS_DT_CN VISIBLE;
ALTER TABLE walking_trail MODIFY COURS_LV_NM VISIBLE;
ALTER TABLE walking_trail MODIFY COURS_NM VISIBLE;
ALTER TABLE walking_trail MODIFY COURS_TM_CN VISIBLE;
ALTER TABLE walking_trail MODIFY CTPRVN_NM VISIBLE;
ALTER TABLE walking_trail MODIFY LC_LA VISIBLE;
ALTER TABLE walking_trail MODIFY LC_LO VISIBLE;
ALTER TABLE walking_trail MODIFY LNM_ADDR VISIBLE;
ALTER TABLE walking_trail MODIFY OPTN_DC VISIBLE;
ALTER TABLE walking_trail MODIFY SIGNGU_NM VISIBLE;
ALTER TABLE walking_trail MODIFY TOILET_DC VISIBLE;
ALTER TABLE walking_trail MODIFY WLK_CREATE_DT VISIBLE;
ALTER TABLE walking_trail MODIFY WLK_MODIFIED_DT VISIBLE;
> COL [ A B ]

-- 다시 순서대로 보이도록 한다.
ALTER TABLE 테이블명 MODIFY COL_C VISIBLE;
ALTER TABLE 테이블명 MODIFY COL_D VISIBLE;

> COL [ A B C D ]
 
* 12c 이상에선 참 쉽다.
 
 
쿼리에서의 문제는 위도(WTH_LA)와 경도(WTH_LO) 값이 뒤바뀌었다는 점입니다. 일반적으로 위도(Latitude)는 남북 방향의 위치를 나타내며, 경도(Longitude)는 동서 방향의 위치를 나타냅니다. 따라서, WTH_LA는 35.15058874로, WTH_LO는 129.012454로 변경해야 합니다.

수정된 쿼리는 다음과 같습니다:

sql

SELECT 
    REG_ID 
FROM
    WEATHER 
WHERE
    WTH_LA <= 35.15058874 + 0.1 
    AND WTH_LA >= 35.15058874 - 0.1 
    AND WTH_LO <= 129.012454 + 0.1 
    AND WTH_LO >= 129.012454 - 0.1;
    
    
    DECLARE
  v_table_name VARCHAR2(100) := 'WALKING_TRAIL'; -- 테이블 이름을 입력하세요.
  v_column_name VARCHAR2(100) := 'SIGNGU_NM'; -- 컬럼 이름을 입력하세요.
  v_sql_stmt VARCHAR2(1000);
  v_update_count INTEGER := 0;
BEGIN
  -- 동적 SQL문 생성: 두 번째 단어만 추출하여 업데이트
  v_sql_stmt := 'UPDATE ' || v_table_name || 
                ' SET ' || v_column_name || ' = REGEXP_SUBSTR(' || v_column_name || ', ''\S+'', 1, 2) ' ||
                'WHERE REGEXP_INSTR(' || v_column_name || ', ''\S+'', 1, 2) > 0';

  -- SQL문 실행
  EXECUTE IMMEDIATE v_sql_stmt;

  -- 업데이트된 행 수 확인
  v_update_count := SQL%ROWCOUNT;

  IF v_update_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Updated ' || v_update_count || ' records with second word in column "' || v_column_name || '".');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No records found with more than one word in column "' || v_column_name || '".');
  END IF;
END;
/

    

    