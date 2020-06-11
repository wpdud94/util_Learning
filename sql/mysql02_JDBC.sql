-- JDBC와 같이 사용
create table person(
	ssn int primary key,
    name varchar(20),
    address varchar(50));
    
desc person;

select ssn, name, address from person; 

Insert into person Values(222, '김희애', '서초동');

delete from person where ssn = 123;