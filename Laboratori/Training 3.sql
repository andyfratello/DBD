/*
Ex. 1
Suposa que volem mantenir informació dels diferents tipus de peixos d'aquari. Concretament, volem mantenir el nom tècnic de l'espècie (en llatí), la família a la qual pertanyen, el color que presenten, el mecanisme de reproducció i la seva raresa. Tingues en compte que dins d'una família de peixos n'hi ha que són més o menys rars, totes les espècies de la mateixa família tenen el mateix mecanisme de reproducció, una espècie pertany només a una família i que tots els peixos d'una espècie tenen el mateix color. També sabem que no pot haver dues espècies dins de la mateixa família que tinguin el mateix color.

Peixos(especie, familia, color, reproduccio, raresa)

Normalitza-ho tenint en compte que la solució ha de constar d'una sèrie "CREATE TABLES" on no importa el nom que doneu a les taules, ni els tipus de dades que utilitzeu, pero sí els noms dels atributs (que han de coincidir exactament amb els de la relació donada). A més, cal que no oblideu definir les claus foranes i alternarives (UNIQUE+NOT NULL) necessàries. Considerarem també que els atributs que no siguin clau candidata admeten valor nul.
*/

CREATE TABLE Familia (familia varchar(1),
reproduccio varchar(1),
PRIMARY KEY (familia)
);
 
CREATE TABLE Peixos (
especie varchar(1),
color varchar(1) NOT NULL,
familia varchar(1) NOT NULL,
raresa varchar(1),
PRIMARY KEY (especie),
UNIQUE (familia,color),
FOREIGN KEY (familia) REFERENCES Familia (familia)
);


/*
Ex. 2
Volem mantenir informació sobre el PIB dels països, el deute que mantenen entre ells i sobre agències de qualificació que existeixen en els països. Per crear la base de dades, partim d'aquesta relació:

R(ag, paisAg, pib, paisD, paisAc, deute)


Coneixem aquestes dependències:

ag -> paisAg
paisD, paisAc -> deute
paisAg -> pib


Feu servir l'algoritme d'anàlisi per obtenir un model normalitzat. Si hi ha diverses solucions, trieu aquella en què hi hagi alguna taula T tal que:

* T és referenciada per una altra taula que no és T
* T conté una clau forana que referencia una altra taula que no és T.


Tingueu en compte que la solució ha de constar d'una sèrie "CREATE TABLES" on no importa el nom que doneu a les taules, ni els tipus de dades que utilitzeu, pero sí els noms dels atributs (que han de ser exactament els que apareixen a la relació de partida). A més, cal que no oblideu definir les claus foranes i alternarives (UNIQUE+NOT NULL) necessàries. Considerarem també que els atributs que no siguin clau candidata admeten valor nul.
*/

CREATE TABLE DPQ (
paisD varchar(1),
paisAc varchar(1),
deute varchar(1),
PRIMARY KEY (paisD, paisAc)
);
 
CREATE TABLE SJ (
paisAg varchar(1),
pib varchar(1),
PRIMARY KEY (paisAg)
);
 
CREATE TABLE CS (
ag varchar(1),
paisAg varchar(1),
PRIMARY KEY (ag),
FOREIGN KEY (paisAg) REFERENCES SJ (paisAg)
);

CREATE TABLE T (
paisD varchar(1),
paisAc varchar(1),
ag varchar(1),
PRIMARY KEY(ag, paisD, paisAc),
FOREIGN KEY (paisD, paisAc) REFERENCES DPQ (paisD, paisAc),
FOREIGN KEY (ag) REFERENCES CS (ag));


/*
Ex. 3
Suposa que tenim una taula CentMilResp(ref, pobl, edat, cand, val) (pots trobar la sentencia de creació al fitxer adjunt).
D=1seg; C=0; BT=10000; |T| = 100000; Ndist(pobl)= 200; Ndist(edat)=100; Ndist(cand)=10
La mitjana d'informació de control per tupla ocupa el mateix que un atribut
Tots els atributs ocupen el mateix i la freqüència de les consultes és:
35%: SELECT cand, MAX(val) FROM CentMilResp GROUP BY cand;
20%: SELECT cand, edat, AVG(val), MAX(val), MIN(val) FROM CentMilResp GROUP BY cand, edat;
20%: SELECT pobl, MAX(val) FROM CentMilResp GROUP BY cand, pobl;
25%: SELECT pobl, MAX(val) FROM CentMilResp GROUP BY pobl;
Considera les dades donades i fes servir l'algorisme greedy per a decidir quines vistes materialitzar (suposant que el temps de la update window és il·limitat, que tenim 10140 blocs de disc i donant preferència a vistes que coincideixen amb alguna consulta en cas d'empat). Suposa també que el mecanisme de rescriptura és prou bo com per utilitzar una vista materialitzada encara que no coincideixi exactament amb la consulta si amb la informació de la vista es pot calcular el que especifica la consulta.

Manté sempre els noms dels atributs de la taula original (es a dir, no utilitzis cap alias a la definició de la vista). Totes les vistes han de tenir la reescriptura activada, construir-se de forma inmediata y refrescar-se de forma completa sota demanda.

Fitxer adjunt:
CREATE TABLE CentMilResp(
  ref INTEGER PRIMARY KEY,
  pobl INTEGER NOT NULL,
  edat INTEGER NOT NULL,
  cand INTEGER NOT NULL,
  val INTEGER NOT NULL,
  UNIQUE (pobl, edat, cand)
);
*/

CREATE materialized view viewC1
build immediate
refresh complete on demand enable query rewrite as
SELECT cand, MAX(val) FROM CentMilResp GROUP BY cand;

CREATE materialized view viewC5
build immediate
refresh complete on demand enable query rewrite as
SELECT cand, pobl, MAX(val) FROM CentMilResp GROUP BY cand, pobl;


/*
Ex. 4
Suposa que tenim una taula CentMilResp(ref, pobl, edat, cand, val) (pots trobar la sentencia de creació al fitxer adjunt).
D=1seg; C=0; BT=10000; |T| = 100000; Ndist(pobl)= 200; Ndist(edat)=100; Ndist(cand)=10
La mitjana d'informació de control per tupla ocupa el mateix que un atribut
Tots els atributs ocupen el mateix i la freqüència de les consultes és:
15%: SELECT cand, AVG(val) FROM CentMilResp GROUP BY cand;
15%: SELECT cand, edat, AVG(val), MAX(val) FROM CentMilResp GROUP BY cand, edat;
70%: SELECT edat, pobl, MAX(val), AVG(val) FROM CentMilResp GROUP BY edat, pobl;
Considera les dades donades i fes servir l'algorisme greedy per a decidir quines vistes materialitzar (suposant que el temps de la update window és il·limitat, que tenim 10100 blocs de disc i donant preferència a vistes que coincideixen amb alguna consulta en cas d'empat). Suposa també que el mecanisme de rescriptura és prou bo com per utilitzar una vista materialitzada encara que no coincideixi exactament amb la consulta si amb la informació de la vista es pot calcular el que especifica la consulta.

Manté sempre els noms dels atributs de la taula original (es a dir, no utilitzis cap alias a la definició de la vista). Totes les vistes han de tenir la reescriptura activada, construir-se de forma inmediata y refrescar-se de forma completa sota demanda.

Fitxer adjunt
CREATE TABLE CentMilResp(
  ref INTEGER PRIMARY KEY,
  pobl INTEGER NOT NULL,
  edat INTEGER NOT NULL,
  cand INTEGER NOT NULL,
  val INTEGER NOT NULL
);
*/

CREATE MATERIALIZED VIEW viewC2
BUILD IMMEDIATE
REFRESH
COMPLETE
ON DEMAND
ENABLE QUERY REWRITE
AS SELECT cand, edat, COUNT(*) , AVG(val), MAX(val) FROM CentMilResp GROUP BY cand, edat;


/*
Ex. 5
Suposa que tenim una taula T(A,B,C,D) (pots trobar la sentencia de creació al fitxer adjunt).
D=1seg; C=0; BT=1000; |T| = 50000; Ndist(A)= 500; Ndist(B)=4000; Ndist(C)=40000; Ndist(D)=5
La mitjana d'informació de control per tupla ocupa el mateix que un atribut
Tots quatre atributs ocupen el mateix i la freqüència de les consultes és:
20%: SELECT A, B, SUM(C) FROM T GROUP BY A, B;
30%: SELECT A, C, SUM(B) FROM T GROUP BY A, C;
30%: SELECT A, SUM(B), SUM(C), SUM(D), COUNT(*) FROM T GROUP BY A;
20%: SELECT A, D, SUM(B) FROM T GROUP BY A, D;
Considera les dades donades i que només ens plantegem la materialització de les vistes que coincideixen exactament amb aquestes consultes (que anomenarem respectivament V1, V2, V3 i V4). Fes servir l'algorisme greedy per a decidir quines vistes materialitzar (suposant que el temps de la update window és il·limitat, però tenim només 2000 blocs de disc).

Posa sempre els atributs seguint l'ordre en que apareixen a la taula. Totes les vistes han de tenir la reescriptura activada, construir-se de forma inmediata y refrescar-se de forma completa sota demanda.

Fitxer adjunt:
CREATE TABLE T (
  A INTEGER,
  B INTEGER,
  C INTEGER NOT NULL,
  D INTEGER NOT NULL,
  PRIMARY KEY (A, B)
);
*/

CREATE MATERIALIZED VIEW V3
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
SELECT A, SUM(B), SUM(C), SUM(D), COUNT(*) FROM T GROUP BY A;

CREATE MATERIALIZED VIEW V4
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
SELECT A, D, SUM(B) FROM T GROUP BY A, D;

CREATE MATERIALIZED VIEW V2
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
SELECT A, C, SUM(B) FROM T GROUP BY A, C;


