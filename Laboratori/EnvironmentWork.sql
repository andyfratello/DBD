-- Exercici 1

/*
Obtenir els noms dels empleats del departament número 5 i l'edifici on treballen. El resultat es vol ordenat ascendentment per nom d'empleat.

Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

NOM_EMP EDIFICI
------- ---------------------------
EULALIA MUNTANER
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

INSERT INTO  DEPARTAMENTS VALUES (5,'MARKETING',3,'MUNTANER','BARCELONA');

INSERT INTO  EMPLEATS VALUES (3,'EULALIA',25000,'MADRID',5,null);

COMMIT;

--Solució
SELECT DISTINCT nom_empl, edifici
FROM DEPARTAMENTS NATURAL JOIN EMPLEATS
WHERE NUM_DPT = 5
ORDER BY nom_empl ASC

---------------------------------------------------------------------------

-- Exercici 2

/*
Obtenir el nom i el sou dels empleats que treballen als departaments 1 o 2. El resultat s'ha d'ordenar ascendentment per nom i per sou.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NOM_EMP SOU
------- ---------------------------
MIQUEL 25000
ROBERTO 25000
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

INSERT INTO  DEPARTAMENTS VALUES (1,'MARKETING',3,'RIOS ROSAS','BARCELONA');
INSERT INTO  DEPARTAMENTS VALUES (2,'DIRECCIO',8,'RIOS ROSAS','MADRID');

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'MADRID',1,null);
INSERT INTO  EMPLEATS VALUES (4,'MIQUEL',25000,'MADRID',2,null);


COMMIT;

--Solució
SELECT DISTINCT nom_empl, sou
FROM EMPLEATS
WHERE NUM_DPT IN (1,2)
ORDER BY nom_empl, sou ASC

---------------------------------------------------------------------------

-- Exercici 3

/*
Obtenir el número i nom dels departaments que tenen 2 o més empleats que viuen a la mateixa ciutat.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NUM_DPT NOM_DPT
------- ---------------------------
3 MARKETING
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

INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'RIOS ROSAS','MADRID');

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'BARCELONA',3,null);
INSERT INTO  EMPLEATS VALUES (5,'EULALIA',150000,'BARCELONA',3,null);

COMMIT;

--Solució
select num_dpt, nom_dpt
from departaments natural join empleats e
group by num_dpt, nom_dpt
having count(*) >= count(distinct e.ciutat_empl)

---------------------------------------------------------------------------

-- Exercici 4

/*
Obtenir el número i el nom dels departaments que no tenen cap empleat que visqui a MADRID.
Ordeneu el resultat pel nom de departament ascendentment.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NUM_DPT NOM_DPT
------- ---------------------------
3 MARKETING
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

INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'RIOS ROSAS','MADRID');

INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'ZAMORA',3,1);

COMMIT;

--Solució
SELECT d.num_dpt, d.nom_dpt
FROM departaments d
WHERE NOT EXISTS (SELECT CIUTAT_DPT
				  FROM EMPLEATS e
				  WHERE e.CIUTAT_EMPL = 'MADRID' AND d.NUM_DPT = e.NUM_DPT)
ORDER BY NOM_DPT ASC
