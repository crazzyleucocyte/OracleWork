select REASON4STUDY, REASONFORSTUDY
from studytab;

SET SERVEROUTPUT ON;


SET SERVEROUTPUT ON;  -- DBMS_OUTPUT 활성화

DECLARE
    v_column_name VARCHAR2(255);
    v_sql         VARCHAR2(4000);
    v_count       NUMBER;
BEGIN
    -- 테이블 이름을 대문자로 입력하세요.
    FOR rec IN (
        SELECT column_name
        FROM user_tab_columns
        WHERE table_name = 'STUDYTAB'  -- 여기에서 YOURTABLENAME을 대문자로 변경하세요.
    ) LOOP
        v_column_name := rec.column_name;

        -- 해당 컬럼의 NULL이 아닌 값의 개수를 세는 쿼리 생성
        v_sql := 'SELECT COUNT(*) FROM YOURTABLENAME WHERE ' || v_column_name || ' IS NOT NULL';

        -- 동적으로 쿼리 실행
        EXECUTE IMMEDIATE v_sql INTO v_count;

        -- NULL이 아닌 값의 개수가 0이면, 해당 컬럼의 모든 값이 NULL이라는 의미
        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE(v_column_name || ' has all NULL values.');
        END IF;
    END LOOP;
END;

/
SELECT table_name FROM user_tables;
SELECT * 
FROM ALL_TAB_PRIVS 
WHERE TABLE_NAME = 'IMAGETAB' AND GRANTEE = USER;
SELECT OWNER, TABLE_NAME 
FROM ALL_TABLES 
WHERE TABLE_NAME = 'IMAGETAB';
SELECT OWNER, TABLE_NAME 
FROM ALL_TABLES 
WHERE TABLE_NAME = 'IMAGETAB';
SELECT * 
FROM ALL_TAB_PRIVS 
WHERE TABLE_NAME = 'IMAGETAB' AND GRANTEE = 'DICOM';

GRANT SELECT ON DICOM.IMAGETAB TO DICOM;
SELECT * 
FROM ALL_TAB_PRIVS 
WHERE TABLE_NAME = 'IMAGETAB' AND GRANTEE = 'DICOM';
SELECT * 
FROM USER_TAB_PRIVS 
WHERE TABLE_NAME = 'IMAGETAB';

SELECT TABLE_NAME 
FROM ALL_TABLES 
WHERE OWNER = 'DICOM';

SELECT USER FROM DUAL;








