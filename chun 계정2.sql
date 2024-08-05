select * from tb_grade order by student_no desc, term_no;

select student_no, count(*) from tb_grade group by student_no;

select student_no, count(*) 
    from tb_grade 
    where term_no like '%1' or term_no like '%2'
    group by student_no
    HAVING student_no='A013116';

