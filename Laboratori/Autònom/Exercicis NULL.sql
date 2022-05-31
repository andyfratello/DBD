/*
Exercici 1
Per a cada projecte que té el valor nul a la columna "pressupost", obtenir la suma dels sous dels empleats assignats al projecte. Ordeneu el resultat per número de projecte..
Per als projectes sense empleats doneu NULL com a suma dels sous.

Per al joc de proves que trobareu al fitxer adjunt, la sortida seria:

NUM_PROJ SUM
_________ ____
1 40000

Fitxer adjunt:
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
	
INSERT INTO  PROJECTES VALUES (1,'IBDVID','VIDEO',NULL);
INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'ZAMORA',NULL,1);
INSERT INTO  EMPLEATS VALUES (6,'MARTA',15000,'ZAMORA',NULL,1);
*/

--Solució

SELECT p.NUM_PROJ, SUM(e.SOU) AS suma_sou
FROM PROJECTES p, EMPLEATS e
WHERE p.NUM_PROJ = e.NUM_PROJ AND p.PRESSUPOST IS NULL
GROUP BY p.NUM_PROJ 
ORDER BY p.NUM_PROJ;


/*
Exercici 2
Doneu una sentència SQL per obtenir el número de llicència dels boletaires que han fet una troballa en un lloc on ningú més ha trobat bolets. Si el lloc d'una troballa és nul, considerem que aquest lloc és diferent al de qualsevol altra troballa amb lloc no nul. Dues troballes amb lloc nul es consideren fetes al mateix lloc. Ordeneu el resultat per número de llicència.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

numLlicencia
538

Fitxer adjunt:
-- SentËncies de preparaciÛ de la base de dades:
create table bolets 
(especie char(20) primary key, 
comestible char (1) not null check ((comestible = 'S') or (comestible = 'N')), 
valor integer not null check (valor >= 0 and valor <= 10), 
check ((comestible = 'S') or (valor = 0)) ); 

create table boletaires 
(nom char(20) primary key, 
numLlicencia integer unique, 
ciutat char(20), 
edat integer check (edat >= 18) ); 

create table troballes 
(nom char(20), 
especie char(20), 
jornada integer, 
quantitat integer check (quantitat > 0), 
lloc char(20), 
primary key (nom, especie, jornada), 
foreign key (nom) references boletaires, 
foreign key (especie) references bolets);

--------------------------
-- Joc de proves P˙blic
--------------------------

-- SentËncies d'inicialitzaciÛ:
insert into bolets values ('mataparents', 'N', 0); 
insert into bolets values ('llanega negra', 'S', 10); 
insert into bolets values ('cep', 'S', 10); 

insert into boletaires values ('Pep', 538, null, 21); 

insert into troballes values ('Pep', 'llanega negra', 4, 12, 'Cadi');
*/

--Solució
SELECT b.NUMLLICENCIA 
FROM BOLETAIRES b, TROBALLES t
WHERE b.NOM = t.NOM AND NOT EXISTS (SELECT * 
									FROM TROBALLES t2
									WHERE t.nom <> t2.nom AND  (t.lloc = t2.lloc OR (t2.lloc IS NULL AND t.lloc IS NULL)))
GROUP BY b.NUMLLICENCIA
ORDER BY b.NUMLLICENCIA;



