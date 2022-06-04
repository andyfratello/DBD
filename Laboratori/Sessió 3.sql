/*
Ex. 1
Donat l'esquema adjunt, comproveu si es pot introduir alguna fila en alguna taula. Modifiqueu, si cal, l'esquema eliminant restriccions (el mínim nombre possible, triant amb sentit comú) per tal que es pugui.
Tingueu present el significat que donem als atributs:

Deute: la quantitat que es deu per comandes no pagades
Crèdit: el valor màxim que pot assolir el deute
Despesa: suma de quantitats corresponents a comandes fetes

Fitxer adjunt:

CREATE TABLE Fabricant
(
	nom VARCHAR (20),
	prestigi INTEGER
		CONSTRAINT NN_Fabricant_prestigi NOT NULL
		CONSTRAINT CK_Fabricant_prestigi_0 CHECK (prestigi >= 1)
		CONSTRAINT CK_Fabricant_prestigi_1 CHECK (prestigi <= 100)
		CONSTRAINT CK_Fabricant_prestigi_2 CHECK (prestigi <= 150),
	deute REAL CONSTRAINT NN_Fabricant_deute NOT NULL
		CONSTRAINT CK_Fabricant_deute_0 CHECK (deute >= 0),
	despesa REAL NOT NULL
		CONSTRAINT CK_Fabricant_despesa_0 CHECK (despesa >= 0),
	credit REAL NOT NULL
		CONSTRAINT CK_Fabricant_credit_0 CHECK (credit >= 0),
	pais VARCHAR (20) NOT NULL CONSTRAINT CK_Fabricant_pais CHECK (pais = 'EEUU' OR pais = 'UK' OR pais = 'Franca'),
	CONSTRAINT UN_Fabricant_0 UNIQUE (prestigi),
	CONSTRAINT PK_Fabricant PRIMARY KEY (nom),
	CONSTRAINT CK_Fabricant_1 CHECK (despesa > credit),
    CONSTRAINT CK_Fabricant_2 CHECK (deute < credit),
    CONSTRAINT CK_Fabricant_3 CHECK (deute > despesa)
);


CREATE TABLE Avio
(
	matricula VARCHAR (20),
	capacitat INTEGER
		CONSTRAINT CK_Avio_capacitat_0 CHECK (capacitat > 0),
	autonomia REAL
		CONSTRAINT CK_Avio_autonomia_0 CHECK (autonomia > 0),
	prestigiFabricant INTEGER CONSTRAINT NN_Avio_prestigi NOT NULL
		CONSTRAINT CK_Avio_prestigiFabricant_0 CHECK (prestigiFabricant > 200),
	CONSTRAINT PK_Avio PRIMARY KEY (matricula),
	CONSTRAINT FK_Avio_0 FOREIGN KEY (prestigiFabricant) REFERENCES Fabricant (prestigi) ON DELETE CASCADE
);


CREATE TABLE Companyia
(
	nom VARCHAR (20),
	sigles VARCHAR (5)
		CONSTRAINT NN_Companyia_sigles NOT NULL,
	capital REAL
		CONSTRAINT CK_Companyia_capital_0 CHECK (capital > 0),
	matricula VARCHAR (20)
		CONSTRAINT NN_Companyia_matricula NOT NULL,
	CONSTRAINT PK_Companyia PRIMARY KEY (nom),
	CONSTRAINT FK_Companyia_0 FOREIGN KEY (matricula) REFERENCES Avio (matricula) ON DELETE CASCADE,
	CONSTRAINT UN_Companyia_0 UNIQUE (sigles)
);


CREATE TABLE propietari
(
	matricula VARCHAR (20),
	nom VARCHAR (20)
		CONSTRAINT NN_propietari_nom NOT NULL,
	CONSTRAINT PK_propietari PRIMARY KEY (matricula),
	CONSTRAINT FK_propietari_0 FOREIGN KEY (matricula) REFERENCES Avio (matricula) ON DELETE CASCADE,
	CONSTRAINT FK_propietari_1 FOREIGN KEY (nom) REFERENCES Companyia (nom) ON DELETE CASCADE
);
*/

CREATE TABLE Fabricant
(
	nom VARCHAR (20),
	prestigi INTEGER
		CONSTRAINT NN_Fabricant_prestigi NOT NULL
		CONSTRAINT CK_Fabricant_prestigi_0 CHECK (prestigi >= 1)
		CONSTRAINT CK_Fabricant_prestigi_1 CHECK (prestigi <= 100)
		CONSTRAINT CK_Fabricant_prestigi_2 CHECK (prestigi <= 150),
	deute REAL CONSTRAINT NN_Fabricant_deute NOT NULL
		CONSTRAINT CK_Fabricant_deute_0 CHECK (deute >= 0),
	despesa REAL NOT NULL
		CONSTRAINT CK_Fabricant_despesa_0 CHECK (despesa >= 0),
	credit REAL NOT NULL
		CONSTRAINT CK_Fabricant_credit_0 CHECK (credit >= 0),
	pais VARCHAR (20) NOT NULL CONSTRAINT CK_Fabricant_pais CHECK (pais = 'EEUU' OR pais = 'UK' OR pais = 'Franca'),
	CONSTRAINT UN_Fabricant_0 UNIQUE (prestigi),
	CONSTRAINT PK_Fabricant PRIMARY KEY (nom),
	CONSTRAINT CK_Fabricant_1 CHECK (despesa > credit),
    CONSTRAINT CK_Fabricant_2 CHECK (deute < credit)
);

CREATE TABLE Avio
(
	matricula VARCHAR (20),
	capacitat INTEGER
		CONSTRAINT CK_Avio_capacitat_0 CHECK (capacitat > 0),
	autonomia REAL
		CONSTRAINT CK_Avio_autonomia_0 CHECK (autonomia > 0),
	prestigiFabricant INTEGER CONSTRAINT NN_Avio_prestigi NOT NULL
		CONSTRAINT CK_Avio_prestigiFabricant_0 CHECK (prestigiFabricant > 200),
	CONSTRAINT PK_Avio PRIMARY KEY (matricula),
	CONSTRAINT FK_Avio_0 FOREIGN KEY (prestigiFabricant) REFERENCES Fabricant (prestigi) ON DELETE CASCADE
);


CREATE TABLE Companyia
(
	nom VARCHAR (20),
	sigles VARCHAR (5)
		CONSTRAINT NN_Companyia_sigles NOT NULL,
	capital REAL
		CONSTRAINT CK_Companyia_capital_0 CHECK (capital > 0),
	matricula VARCHAR (20)
		CONSTRAINT NN_Companyia_matricula NOT NULL,
	CONSTRAINT PK_Companyia PRIMARY KEY (nom),
	CONSTRAINT FK_Companyia_0 FOREIGN KEY (matricula) REFERENCES Avio (matricula) ON DELETE CASCADE,
	CONSTRAINT UN_Companyia_0 UNIQUE (sigles)
);


CREATE TABLE propietari
(
	matricula VARCHAR (20),
	nom VARCHAR (20)
		CONSTRAINT NN_propietari_nom NOT NULL,
	CONSTRAINT PK_propietari PRIMARY KEY (matricula),
	CONSTRAINT FK_propietari_0 FOREIGN KEY (matricula) REFERENCES Avio (matricula) ON DELETE CASCADE,
	CONSTRAINT FK_propietari_1 FOREIGN KEY (nom) REFERENCES Companyia (nom) ON DELETE CASCADE
);


INSERT INTO Fabricant VALUES ('s',2,5,10,8,'UK');

/*
Ex. 2

A partir de la solució de la pregunta anterior, penseu si ara es poden inserir tuples a totes les taules o només en algunes. Modifiqueu, si cal, l'esquema eliminant restriccions (el mínim nombre possible, triant amb sentit comú) per poder fer insercions a totes les taules.
*/


CREATE TABLE Fabricant
(
	nom VARCHAR (20),
	prestigi INTEGER
		CONSTRAINT NN_Fabricant_prestigi NOT NULL
		CONSTRAINT CK_Fabricant_prestigi_0 CHECK (prestigi >= 1)
		CONSTRAINT CK_Fabricant_prestigi_1 CHECK (prestigi <= 100)
		CONSTRAINT CK_Fabricant_prestigi_2 CHECK (prestigi <= 150),
	deute REAL CONSTRAINT NN_Fabricant_deute NOT NULL
		CONSTRAINT CK_Fabricant_deute_0 CHECK (deute >= 0),
	despesa REAL NOT NULL
		CONSTRAINT CK_Fabricant_despesa_0 CHECK (despesa >= 0),
	credit REAL NOT NULL
		CONSTRAINT CK_Fabricant_credit_0 CHECK (credit >= 0),
	pais VARCHAR (20) NOT NULL CONSTRAINT CK_Fabricant_pais CHECK (pais = 'EEUU' OR pais = 'UK' OR pais = 'Franca'),
	CONSTRAINT UN_Fabricant_0 UNIQUE (prestigi),
	CONSTRAINT PK_Fabricant PRIMARY KEY (nom),
	CONSTRAINT CK_Fabricant_1 CHECK (despesa > credit),
    CONSTRAINT CK_Fabricant_2 CHECK (deute < credit)
);

CREATE TABLE Avio
(
	matricula VARCHAR (20),
	capacitat INTEGER
		CONSTRAINT CK_Avio_capacitat_0 CHECK (capacitat > 0),
	autonomia REAL
		CONSTRAINT CK_Avio_autonomia_0 CHECK (autonomia > 0),
	prestigiFabricant INTEGER CONSTRAINT NN_Avio_prestigi NOT NULL,
	CONSTRAINT PK_Avio PRIMARY KEY (matricula),
	CONSTRAINT FK_Avio_0 FOREIGN KEY (prestigiFabricant) REFERENCES Fabricant (prestigi) ON DELETE CASCADE
);

CREATE TABLE Companyia
(
	nom VARCHAR (20),
	sigles VARCHAR (5)
		CONSTRAINT NN_Companyia_sigles NOT NULL,
	capital REAL
		CONSTRAINT CK_Companyia_capital_0 CHECK (capital > 0),
	matricula VARCHAR (20)
		CONSTRAINT NN_Companyia_matricula NOT NULL,
	CONSTRAINT PK_Companyia PRIMARY KEY (nom),
	CONSTRAINT FK_Companyia_0 FOREIGN KEY (matricula) REFERENCES Avio (matricula) ON DELETE CASCADE,
	CONSTRAINT UN_Companyia_0 UNIQUE (sigles)
);

CREATE TABLE propietari
(
	matricula VARCHAR (20),
	nom VARCHAR (20)
		CONSTRAINT NN_propietari_nom NOT NULL,
	CONSTRAINT PK_propietari PRIMARY KEY (matricula),
	CONSTRAINT FK_propietari_0 FOREIGN KEY (matricula) REFERENCES Avio (matricula) ON DELETE CASCADE,
	CONSTRAINT FK_propietari_1 FOREIGN KEY (nom) REFERENCES Companyia (nom) ON DELETE CASCADE
);


INSERT INTO Fabricant VALUES ('s',2,5,10,8,'UK');
INSERT INTO Avio VALUES ('11',30,5,2);
INSERT INTO Companyia VALUES ('aa','vv',30,'11');
INSERT INTO propietari VALUES ('11','aa');

/*
Ex. 3
A partir de la solució de la pregunta anterior, pensa si la vista compInsFUK2 té lapropietat de liveliness. En cas afirmatiu, proposa uns INSERT (el mínim nombre possible) d'exemple. En cas negatiu, no responguis a través del corrector; justifica la resposta en paper.

Fitxer adjunt:

CREATE VIEW compNoInsUK AS (
 SELECT C.nom as compNom, A.matricula, F.nom as fabNom FROM Companyia C, Avio A, Fabricant F WHERE C.matricula = A.matricula AND A.prestigiFabricant = F.prestigi AND F.pais <> 'UK');
 
 
CREATE VIEW compInsUK AS (
 SELECT C.nom as compNom, A.matricula, F.nom as fabNom  FROM Companyia C, Avio A, Fabricant F WHERE C.matricula = A.matricula AND A.prestigiFabricant = F.prestigi AND F.pais = 'UK');
 
 
CREATE VIEW compInsFUK AS (
 SELECT C.nom as compNom, A.matricula, F.nom as fabNom  FROM Companyia C, Avio A, Fabricant F WHERE C.matricula = A.matricula AND A.prestigiFabricant = F.prestigi AND F.pais = 'UK' AND F.pais = 'Franca');
 
 CREATE VIEW compInsFUK2 AS (
 SELECT C.nom as compNom, A.matricula, F.nom as fabNom  FROM Companyia C, Avio A, Fabricant F WHERE C.matricula = A.matricula AND A.prestigiFabricant = F.prestigi AND (F.pais = 'UK' OR F.pais = 'Franca'));
*/

INSERT INTO Fabricant VALUES ('s',2,5,10,8,'UK');
INSERT INTO Avio VALUES ('11',30,5,2);
INSERT INTO Companyia VALUES ('aa','vv',30,'11');

/*
Ex. 4

Suposa que tenim una taula T(A,B,C,D) (pots trobar la sentencia de creació al fitxer adjunt).

    D=1seg; C=0; BT=1000; |T| = 50000; Ndist(A)= 500; Ndist(B)=4000
    La mitjana d'informació de control per tupla ocupa el mateix que un atribut
    Tots quatre atributs ocupen el mateix i la freqüència de les consultes és:
        1. 30%: SELECT A, SUM(B), SUM(C), SUM(D) FROM T GROUP BY A;
        2. 33%: SELECT B, SUM(C), SUM(D) FROM T GROUP BY B;
        3. 37%: SELECT SUM(C), SUM(D) FROM T; 

Considera les dades donades i fes servir l'algorisme greedy per a decidir quines vistes materialitzar (suposant que el temps de la update window és il·limitat, que tenim 1048 blocs de disc i donant preferència a vistes que coincideixen amb alguna consulta en cas d'empat). Suposa també que el mecanisme de rescriptura és prou bo com per utilitzar una vista materialitzada encara que no coincideixi exactament amb la consulta.

Manté sempre els noms dels atributs de la taula original (es a dir, no utilitzis cap alias a la definició de la vista). Totes les vistes han de tenir la reescriptura activada, construir-se de forma inmediata y refrescar-se de forma completa sota demanda.

Fitxer adjunt:

CREATE TABLE T (
  A INTEGER,
  B INTEGER,
  C INTEGER,
  D INTEGER NOT NULL,
  PRIMARY KEY (A, B, C)
);
*/

CREATE MATERIALIZED VIEW V1
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND ENABLE QUERY REWRITE AS
SELECT A, SUM(B), SUM(C), SUM(D) FROM T GROUP BY A;

CREATE MATERIALIZED VIEW V3
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND ENABLE QUERY REWRITE AS
SELECT SUM(C), SUM(D) FROM T;
