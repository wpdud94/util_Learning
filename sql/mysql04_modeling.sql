desc cust;

select * from cust;
SELECT id, pass, cust_name, address FROM cust;

update cust set pass = 'pass3', cust_name='아이유', address='청담동' where id = 'id3';

SELECT id, pass, cust_name, address FROM cust WHERE id = 'id1';