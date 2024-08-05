create table signin
as (select student_no as id, substr(student_ssn,0,6) as pwd from tb_student);

select student_no, substr(student_ssn,0,6) from tb_student;

select id, pwd from signin where id='A013116' and pwd='821125';

select * from tb_student join tb_department using(department_no) left join tb_professor on(coach_professor_no=professor_no) where STUDENT_NO='A013116'

