/*
Fitxers adjunts:
------------------------------------------------------------------------
create table pais(nom varchar(25) primary key, hab integer, pib integer);
 
create table emiss(codi integer primary key, pais varchar(25) not null references pais(nom), deute integer not null);
 
create table compte(num varchar(30) primary key, paisTit varchar(25) references pais(nom));
 
create table compres(em integer references emiss(codi), cpte varchar(30) references compte(num), q integer not null, primary key(em, cpte));
 
insert into pais values ('AcidRainia', 1000000, 2);
insert into emiss values (7, 'AcidRainia', 200);
insert into compte values ('2100-0001-62-4729475625', 'AcidRainia');
insert into compte values ('2100-0001-34-5614627893', 'AcidRainia');
insert into compres values (7, '2100-0001-34-5614627893', 20);
insert into compres values (7, '2100-0001-62-4729475625', 50);
------------------------------------------------------------------------
create table pais(nom varchar(25) primary key, hab integer, pib integer);
 
create table emiss(codi integer primary key, pais varchar(25) not null references pais(nom), deute integer not null);
 
create table compte(num varchar(30) primary key, paisTit varchar(25) references pais(nom));
 
create table compres(em integer references emiss(codi), cpte varchar(30) references compte(num), q integer not null, primary key(em, cpte));
 
insert into pais values ('AcidRainia', 1000000, 2);
insert into pais values ('BananaLand', 5000000, 1);
insert into emiss values (3, 'BananaLand', 500);
insert into compte values ('2100-0001-62-4729475625', 'AcidRainia');
insert into compres values (3, '2100-0001-62-4729475625', 50);
------------------------------------------------------------------------
create table pais(nom varchar(25) primary key, hab integer, pib integer);
 
create table emiss(codi integer primary key, pais varchar(25) not null references pais(nom), deute integer not null);
 
create table compte(num varchar(30) primary key, paisTit varchar(25) references pais(nom));
 
create table compres(em integer references emiss(codi), cpte varchar(30) references compte(num), q integer not null, primary key(em, cpte));
 
insert into pais values ('AcidRainia', 1000000, 2);
insert into pais values ('BananaLand', 5000000, 1);
insert into emiss values (3, 'BananaLand', 500);
insert into compte values ('2100-0001-62-4729475625', 'AcidRainia');
insert into compres values (3, '2100-0001-62-4729475625', 50);
------------------------------------------------------------------------
create table pais(nom varchar(25) primary key, hab integer, pib integer);
 
create table emiss(codi integer primary key, pais varchar(25) not null references pais(nom), deute integer not null);
 
create table compte(num varchar(30) primary key, paisTit varchar(25) references pais(nom));
 
create table compres(em integer references emiss(codi), cpte varchar(30) references compte(num), q integer not null, primary key(em, cpte));
 
insert into pais values ('BananaLand', 5000000, 1);
insert into emiss values (3, 'BananaLand', 500);
insert into compte values ('2100-0001-62-4729475625', null);
insert into compres values (3, '2100-0001-62-4729475625', 50);
------------------------------------------------------------------------
*/

/*
Qüestió 1
Doneu una sentència SQL per obtenir, per a cada país, el nombre de compres fetes per comptes que tenen per titular aquest país. Ordeneu el resultat per nom de país.
Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

AcidRainia, 2
*/
 
--Solució:
 
SELECT p.nom, COUNT(cp.cpte)
FROM PAIS p LEFT OUTER JOIN COMPTE c ON p.nom = c.paisTit LEFT OUTER JOIN COMPRES cp ON c.num = cp.cpte
GROUP BY p.nom
ORDER BY p.nom;
 
/*Qüestió 2
Doneu una sentència SQL per obtenir, per a cada emissió, de quants països diferents són els titulars dels comptes compradors, sense comptar el país emissor del deute. El valor nul de país es considera un nou país diferent dels que hi ha a la taula de països. Ordeneu el resultat per codi d'emissió.
Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
 
3, 1
*/

--Solució:
 
SELECT e.codi, COUNT(DISTINCT c.paisTit)
FROM EMISS e LEFT OUTER JOIN COMPRES cp ON e.codi = cp.em LEFT OUTER JOIN COMPTE c ON c.num = cp.cpte
GROUP BY e.codi
ORDER BY e.codi;
 
/*
Qüestió 3 
Doneu una sentència SQL per obtenir, per a cada emissió, de quants països diferents són els titulars dels comptes compradors, sense comptar el país emissor del deute. El valor nul de país es considera un nou país diferent cada vegada que apareix. Ordeneu el resultat per codi d'emissió.
 
Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
 
3, 1
*/
 
--Solució:
 
SELECT e.codi, COUNT(DISTINCT c.paisTit)
FROM EMISS e LEFT OUTER JOIN COMPRES cp ON e.codi = cp.em LEFT OUTER JOIN COMPTE c ON c.num = cp.cpte
GROUP BY e.codi
ORDER BY e.codi;
 
/*Qüestió 4
 
Doneu una sentència SQL per obtenir els comptes per als que no hi ha cap país del qual no hagin comprat deute. Ordeneu el resultat per número de compte.
Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
 
2100-0001-62-4729475625
*/
 
--Solució:
 
SELECT c.cpte
FROM COMPRES c LEFT OUTER JOIN EMISS e ON c.em = e.codi
GROUP BY c.cpte
HAVING COUNT (DISTINCT e.pais) = (SELECT COUNT(*) FROM PAIS);
