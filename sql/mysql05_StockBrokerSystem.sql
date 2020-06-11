select * from customer;
select * from stock;
select * from shares;

INSERT INTO shares(ssn, symbol, quantity) VALUES('111-111', 'JDK', 300);
UPDATE shares set ssn = '123', symbol = 'JDK', quantity = quantity + 500 WHERE ssn='124' AND symbol ='JDK';
delete from shares where ssn = '123';




