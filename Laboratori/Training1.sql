-- Exercici 1

/*
Proposeu una sentència SQL per obtenir, per a tots els projectes, de quantes ciutats són els departaments dels empleats que hi treballen.
Concretament volem, en aquest ordre, el número de projecte, el nom de projecte i el nombre de ciutats.

Per al contingut corrresponent al fitxer adjunt la sortida ha de ser:

NUM_PROJ NOM_PROJ
----------------------------
1 IBDTEL 1
*/

--Fitxer adjunt
CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT));

CREATE TABLE PROJECTES
         (	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ));

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));


INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);
INSERT INTO  DEPARTAMENTS VALUES (1,'DIRECCIO',10,'PAU CLARIS','BARCELONA');
INSERT INTO  EMPLEATS VALUES (1,'CARME',400000,'MATARO',1,1);

--Solució
SELECT p.NUM_PROJ, p.NOM_PROJ, count(DISTINCT ciutat_dpt) AS num_ciutats
FROM PROJECTES p LEFT JOIN EMPLEATS e ON p.NUM_PROJ = e.NUM_PROJ LEFT JOIN DEPARTAMENTS d ON d.NUM_DPT = e.NUM_DPT
GROUP BY p.NUM_PROJ, p.NOM_PROJ
ORDER BY p.NUM_PROJ, p.NOM_PROJ, num_ciutats

--------------------------------------------------------------------------------

-- Exercici 2

/*
Per a cada departament, obtenir el nombre d'empleats de l'empresa que viuen a la ciutat del departament. Ordeneu el resultat per número de departament.

Per al joc de proves que trobareu al fitxer adjunt, la sortida seria:

NUM_DPT COUNT
_________ ____
2 1
*/

--Fitxer adjunt
CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT));

CREATE TABLE PROJECTES
         (	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ));

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));
	
	
INSERT INTO  DEPARTAMENTS VALUES (2,'MARKETING',3,'RIOS ROSAS','ZAMORA');
INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'ZAMORA',2, NULL);

--Solució
SELECT d.NUM_DPT, COUNT(num_empl) AS num_empleats
FROM DEPARTAMENTS d LEFT JOIN EMPLEATS e ON e.CIUTAT_EMPL = d.CIUTAT_DPT
GROUP BY d.NUM_DPT 
ORDER BY num_empleats

--------------------------------------------------------------------------------

-- Exercici 3

/*
Per a cada ciutat de la base de dades (ja sigui de departaments o d'empleats), quants empleats hi treballen. Ordeneu el resultat per ciutat.

Per al joc de proves que trobareu al fitxer adjunt, la sortida seria:

CIUTAT COUNT
______ ____
Barcelona 1
*/

--Fitxer adjunt
CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT));

CREATE TABLE PROJECTES
         (	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ));

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));


INSERT INTO DEPARTAMENTS VALUES (2, NULL, NULL, NULL,'Barcelona');
INSERT INTO  EMPLEATS VALUES (3, NULL, NULL, 'Barcelona', 2, NULL);

commit;

--Solució
SELECT d.CIUTAT_DPT AS ciutat, COUNT(e.NUM_EMPL) AS num_empleats 
FROM DEPARTAMENTS d LEFT JOIN EMPLEATS e ON d.NUM_DPT = e.NUM_DPT
GROUP BY d.CIUTAT_DPT
HAVING d.CIUTAT_DPT IS NOT NULL

UNION 

SELECT e.CIUTAT_EMPL AS ciutat, 0 AS NUM_EMPL 
FROM EMPLEATS e
WHERE e.CIUTAT_EMPL IS NOT NULL AND e.CIUTAT_EMPL NOT IN (SELECT d1.CIUTAT_DPT
														  FROM DEPARTAMENTS d1
														  WHERE d1.CIUTAT_DPT IS NOT NULL)
ORDER BY ciutat

--------------------------------------------------------------------------------

-- Exercici 4

/*
Doneu una sentència SQL per obtenir els domicilis que han fet més comandes. Si només s'han fet comandes a la botiga, volem com a resultat una tupla de valors nuls. Si no hi ha comandes de cap mena, no volem obtenir cap resultat.

Nota: les comandes que s'han fet a la botiga són aquelles que tenen valor nul al telèfon.

Ens interessa concretament el carrer i el número del domicili i volem el resultat ordenat per aquests atributs i en aquest ordre.
Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

nomCarrer	numCarrer
pont	47
*/

--Fitxer adjunt
create table productes
(idProducte char(9),
nom char(20),
mida char(20),
preu integer check(preu>0),
primary key (idProducte),
unique (nom,mida));

create table domicilis
(numTelf char(9),
nomCarrer char(20),
numCarrer integer check(numCarrer>0),
pis char(2),
porta char(2),
primary key (numTelf));

create table comandes
(numComanda integer check(numComanda>0),
instantFeta integer not null check(instantFeta>0),
instantServida integer check(instantServida>0),
numTelf char(9),
import integer check(import>0),
primary key (numComanda),
foreign key (numTelf) references domicilis,
check (instantServida>instantFeta));

create table liniesComandes
(numComanda integer,
idProducte char(9),
quantitat integer check(quantitat>0),
primary key(numComanda,idProducte),
foreign key (numComanda) references comandes,
foreign key (idProducte) references productes);

insert into productes values ('p111', '4 formatges', 'gran', 21);
  
insert into domicilis values ('934131415', 'pont', 47, '4', '2');

insert into comandes values (110, 1091, 1101, '934131415', 42);

insert into liniesComandes values (110, 'p111', 2);

--Solució (no va fer el UNION)
-- Comandes botiga 
SELECT NULL, NULL 
FROM COMANDES c1 
WHERE NOT EXISTS (SELECT *
				  FROM COMANDES c2
				  WHERE c2.NUMTELF IS NOT NULL)
				  
UNION 

-- Comandes a domicili
SELECT d.nomCarrer, d.numCarrer 
FROM DOMICILIS d NATURAL JOIN COMANDES c
GROUP BY d.nomCarrer, d.numCarrer
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
				   FROM DOMICILIS d2 NATURAL JOIN COMANDES c2
				   GROUP BY d2.nomCarrer, d2.numCarrer) 
ORDER BY d.nomCarrer, d.numCarrer

--------------------------------------------------------------------------------

-- Exercici 5

/*
Doneu una sentència SQL per obtenir, de cada producte, quants productes diferents formen part de les comandes en què apareix el producte. Si un producte no ha estat demanat, ha de sortir amb el comptador 0. Ordeneu el resultat per producte.

Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

idProducte	Comptador
p111	1
*/

--Fitxer adjunt
create table productes
(idProducte char(9),
nom char(20),
mida char(20),
preu integer check(preu>0),
primary key (idProducte),
unique (nom,mida));

create table domicilis
(numTelf char(9),
nomCarrer char(20),
numCarrer integer check(numCarrer>0),
pis char(2),
porta char(2),
primary key (numTelf));

create table comandes
(numComanda integer check(numComanda>0),
instantFeta integer not null check(instantFeta>0),
instantServida integer check(instantServida>0),
numTelf char(9),
import integer check(import>0),
primary key (numComanda),
foreign key (numTelf) references domicilis,
check (instantServida>instantFeta));

create table liniesComandes
(numComanda integer,
idProducte char(9),
quantitat integer check(quantitat>0),
primary key(numComanda,idProducte),
foreign key (numComanda) references comandes,
foreign key (idProducte) references productes);

insert into productes values ('p111', '4 formatges', 'gran', 21);
insert into domicilis values ('934131415', 'pont', 47, '4', '2');
insert into comandes values (110, 1091, 1101, '934131415', 42);
insert into liniesComandes values (110, 'p111', 2);

--Solució
SELECT p.IDPRODUCTE, COUNT(DISTINCT lc.IDPRODUCTE) AS Comptador 
FROM PRODUCTES p LEFT JOIN LINIESCOMANDES lc ON p.IDPRODUCTE = lc.IDPRODUCTE
GROUP BY p.IDPRODUCTE
ORDER BY p.IDPRODUCTE

--------------------------------------------------------------------------------

-- Exercici 6

/*
La taula habitacions registra, per a cadascuna, a quina hora cal despertar els hostes (amb les columnes hora i minut). Si l'hora té el valor nul els hostes no volen ser despertats. Doneu una sentència SQL que retorni a quantes hores diferents (sense tenir en compte la columna minut) cal despertar algú. El fet de no voler ser despertat compta com una hora més.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

3
*/

--Fitxer adjunt
CREATE TABLE vigilants(
nom VARCHAR(20) PRIMARY key,
edat integer);

CREATE TABLE rondes(
hora INTEGER,
planta INTEGER,
vigilant VARCHAR(20) REFERENCES vigilants,
PRIMARY KEY(hora, planta));

CREATE TABLE habitacions(
num INTEGER,
planta INTEGER,
places INTEGER,
hora INTEGER,
minut INTEGER,
PRIMARY KEY(num, planta),
FOREIGN KEY(hora, planta) REFERENCES rondes);

INSERT INTO vigilants(nom, edat) VALUES ('Mulder', 32);
INSERT INTO vigilants(nom, edat) VALUES ('Scully', 30);

INSERT INTO rondes(hora, planta, vigilant) VALUES (7, 1, 'Mulder');
INSERT INTO rondes(hora, planta, vigilant) VALUES (8, 1, 'Mulder');
INSERT INTO rondes(hora, planta, vigilant) VALUES (7, 2, 'Mulder');

INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (1, 1, 1, 7, 30);
INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (5, 1, 1, 7, 30);
INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (2, 1, 1, 8, 30);
INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (3, 1, 1, null, null);
INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (4, 1, 1, null, null);
INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (1, 2, 1, null, null);

commit;

--Solució
SELECT count(*)
FROM (SELECT DISTINCT h.hora FROM HABITACIONS h)

