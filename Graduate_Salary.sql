-- creating new database
create database engineering_graduate_salary;

-- using the database
use engineering_graduate_salary;

-- creating empty table with same columns
create table project like engineering_graduate_salary;

select * from project;

-- coping the data into new table
insert project 
	select * from engineering_graduate_salary;

-- checking the null values
select * from project where ID is null or Gender is null;

set sql_safe_updates=0;

 
update project 
	set Gender='Male' where Gender='m';

update project 
	set Gender='Female' where Gender='f';

update project 
	set 10board='other' where 10board='0';

update project 
	set 10board='up board' where 10board='u p board';

update project 
	set 12board='other' where 12board='0';

update project 
	set 12board='up board' where 12board='u p board'; 

-- checking the duplicate values
select 
	ID, count(*) 
from 
	project 
group by 
	ID having count(*)>1;

-- 1) what is the count of the genders?
select
	Gender, count(*) as 'count_of_Genders' 
from 
	project 
group by 
	Gender; 

-- 2) which branch people graduate more in every year?
select 
	Specialization, count(*) as 'Graduate_passed_out' 
from 
	project 
group by 
	Specialization 
order by 
	Graduate_passed_out desc;

-- 3) which year more people graduate?
select 
	GraduationYear, count(*) as 'no_of_Graduates' 
from 
	project 
group by 
	GraduationYear 
order by 
	no_of_Graduates desc;

-- 4) In which year and branch people Graduate more?
select 
	Specialization, GraduationYear, count(*) as 'no_of_Graduates' 
from 
	project 
group by 
	Specialization, GraduationYear 
order by 
	no_of_Graduates desc;

-- 5) which 12board people coming frequently;
select
	12board, count(*) 
from 
	project 
group by 
	12board 
order by 
	count(*) desc; 

-- 6) In which college tier more people frequently joining?
select 
	CollegeTier, count(*) 
from 
	project 
group by 
	CollegeTier 
order by 
	count(*) desc; 

-- 7) In which collegestate student joining more?
select 
	CollegeState, count(*) 
from 
	project 
group by 
	CollegeState 
order by 
	count(*) desc;

-- 8) In which sate and specialization more people are joining?
select 
	CollegeState, Specialization, count(*) 
from 
	project 
group by 
	CollegeState,Specialization 
order by 
	count(*) desc;

-- 9) In which Specialization people getting jobs?
select 
	Specialization, count(Salary) 
from 
	project 
group by 
	Specialization 
order by 
	count(Salary) desc;

-- 10) In which branch people getting highest salary?
select 
	Specialization, Salary, 
    row_number()
    over(partition by  Specialization order by Salary) as 'row_number' 
from 
	project;





































