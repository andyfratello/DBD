/*
Ex. 1
Utilitzant les clàusules del SQL'99 específiques per consultes multidimensionals, i l'esquema en estrella que pots trobar al fitxer adjunt (que representa la història de tots els mossos de tots els Països Catalans, no només a Catalunya), creeu una vista que porti per nom "nomVista" que correspongui a la taula estadística següent:
          Basica	Comand.	Total
Barcelona	100	    4	      104
Tarragona	2	      1	      3
Lleida	  20      1	      21
Girona	  30	    1	      31
Total			                159


La taula conté per l'any 2009, la suma de mossos de l'especialitat "Antidisturbi" que hi ha assignats, a les quatre províncies catalanes, segons si pertanyen a l'escala de rangs bàsica (valor "Basica"), o són comandaments (valor "Comand.", noteu el punt final). Poseu al SELECT els atributs del nom de la escala i província, seguits per la suma de la mesura, exactament en aquest ordre. No cal que rescribiu els valors nuls de la sortida com a 'Total' i no poseu ORDER BY, perque les vistes no ho accepten.

Fitxer adjunt:
CREATE TABLE Perfil (
Id INTEGER PRIMARY KEY,
Sexe CHAR CHECK (sexe='M' OR sexe='F') NOT NULL, Edat INTEGER
);
CREATE TABLE poblacio (
Nom CHAR(30) PRIMARY KEY, Provincia CHAR(10),
Comarca CHAR(15)
);
CREATE TABLE data (
Id DATE PRIMARY KEY,
mes CHAR(8) NOT NULL CHECK (mes IN ('Gener', 'Febrer', 'Marc', 'Abril', 'Maig', 'Juny', 'Juliol', 'Agost', 'Setembre', 'Octubre', 'Novembre', 'Decembre')),
anyo CHAR(4) NOT NULL
);
CREATE TABLE especialitat ( Nom CHAR(12) PRIMARY KEY, Tipus CHAR(18)
);
CREATE TABLE rang (
Nom CHAR(13) PRIMARY KEY, Escala CHAR(9)
);
CREATE TABLE destinacio (
PerfilId INTEGER REFERENCES perfil(id),
PoblacioId CHAR(30) REFERENCES poblacio(nom),
dataId DATE REFERENCES data(id),
especialitatId CHAR(12) REFERENCES especialitat(nom),
rangId CHAR(13) REFERENCES rang(nom),
mossos INTEGER,
PRIMARY KEY (perfilId, poblacioId, especialitatId, rangId, dataId) );
INSERT INTO perfil VALUES (1, 'F', 23);
INSERT INTO especialitat VALUES ('Transit','A');
INSERT INTO especialitat VALUES ('TEDAX','B');
INSERT INTO especialitat VALUES ('Antidisturbi','A');
INSERT INTO rang VALUES ('Mosso', 'Basica');
INSERT INTO rang VALUES ('Caporal', 'Basica');
INSERT INTO rang VALUES ('Inspector', 'Comand.');
INSERT INTO poblacio VALUES ('Badalona', 'Barcelona', 'Barcelones');
INSERT INTO poblacio VALUES ('Hospitalet', 'Barcelona', 'Barcelones');
INSERT INTO poblacio VALUES ('Lleida', 'Lleida', 'Segria');
INSERT INTO poblacio VALUES ('Ponts', 'Lleida', 'Noguera');
INSERT INTO poblacio VALUES ('Tarragona', 'Tarragona', 'Tarragones');
INSERT INTO poblacio VALUES ('Girona', 'Girona', 'Girones');
INSERT INTO data VALUES ('10/10/2003','Octubre', '2003');
INSERT INTO data VALUES ('10/10/2004','Octubre', '2004');
INSERT INTO data VALUES ('10/10/2009','Octubre', '2009');
INSERT INTO destinacio VALUES (1, 'Badalona', '10/10/2003', 'Transit', 'Mosso', 150); INSERT INTO destinacio VALUES (1, 'Badalona', '10/10/2003', 'Transit', 'Caporal', 6); INSERT INTO destinacio VALUES (1, 'Hospitalet', '10/10/2003', 'Transit', 'Mosso', 200); INSERT INTO destinacio VALUES (1, 'Hospitalet', '10/10/2003', 'Transit', 'Caporal', 8); INSERT INTO destinacio VALUES (1, 'Lleida', '10/10/2003', 'Transit', 'Mosso', 201); INSERT INTO destinacio VALUES (1, 'Lleida', '10/10/2003', 'Transit', 'Caporal', 8); INSERT INTO destinacio VALUES (1, 'Ponts', '10/10/2003', 'Transit', 'Mosso', 50); INSERT INTO destinacio VALUES (1, 'Ponts', '10/10/2003', 'Transit', 'Caporal', 2); INSERT INTO destinacio VALUES (1, 'Badalona', '10/10/2004', 'TEDAX', 'Mosso', 200); INSERT INTO destinacio VALUES (1, 'Badalona', '10/10/2004', 'TEDAX', 'Caporal', 20); INSERT INTO destinacio VALUES (1, 'Hospitalet', '10/10/2004', 'TEDAX', 'Mosso', 250); INSERT INTO destinacio VALUES (1, 'Hospitalet', '10/10/2004', 'TEDAX', 'Caporal', 23); INSERT INTO destinacio VALUES (1, 'Lleida', '10/10/2004', 'TEDAX', 'Mosso', 137); INSERT INTO destinacio VALUES (1, 'Lleida', '10/10/2004', 'TEDAX', 'Caporal', 15); INSERT INTO destinacio VALUES (1, 'Ponts', '10/10/2004', 'TEDAX', 'Mosso', 50); INSERT INTO destinacio VALUES (1, 'Ponts', '10/10/2004', 'TEDAX', 'Caporal', 8); INSERT INTO destinacio VALUES (1, 'Tarragona', '10/10/2009', 'Antidisturbi', 'Mosso', 2); INSERT INTO destinacio VALUES (1, 'Tarragona', '10/10/2009', 'Antidisturbi', 'Inspector', 1);
INSERT INTO destinacio VALUES (1, 'Hospitalet', '10/10/2009', 'Antidisturbi', 'Mosso', 100);
INSERT INTO destinacio VALUES (1, 'Hospitalet', '10/10/2009', 'Antidisturbi', 'Inspector', 4);
INSERT INTO destinacio VALUES (1, 'Lleida', '10/10/2009', 'Antidisturbi', 'Mosso', 20); INSERT INTO destinacio VALUES (1, 'Lleida', '10/10/2009', 'Antidisturbi', 'Inspector', 1); INSERT INTO destinacio VALUES (1, 'Girona', '10/10/2009', 'Antidisturbi', 'Mosso', 30); INSERT INTO destinacio VALUES (1, 'Girona', '10/10/2009', 'Antidisturbi', 'Inspector', 1)
*/

CREATE VIEW nomVista AS
SELECT r.escala AS Basica, p.provincia AS Comand, SUM(d.mossos) AS Total
FROM rang r, poblacio p, destinacio d, data da
WHERE d.poblacioId = p.nom AND d.rangId = r.nom AND d.dataID = da.id AND da.anyo = '2009' AND 
d.especialitatId = 'Antidisturbi' AND p.provincia IN ('Barcelona', 'Lleida', 'Tarragona', 'Girona')
GROUP BY ROLLUP(p.provincia,r.escala);


/*
Ex. 2
Utilitzant les clàusules del SQL'99 específiques per consultes multidimensionals, i l'esquema en estrella que pots trobar al fitxer adjunt (que representa la història de tots els mossos de tota Catalunya), creeu una vista que porti per nom "nomVista" que correspongui a la taula estadística següent:

[table]

La taula conté per als anys 2003 i 2004, la suma (d'entre tots els perfils, rangs i poblacions) de mossos de l'especialitat "Transit" i "Investigacio" que hi ha assignats, a les comarques del Barcelones, Segria i Noguera. Poseu al SELECT els atributs de la comarca, provincia, especialitat i any, seguits de la suma de la mesura, exactament en aquest ordre. No cal que rescribiu els valors nuls de la sortida com a 'Total' i no poseu ORDER BY, perque les vistes no ho accepten.

Fitxer adjunt:
CREATE TABLE Perfil (
Id INTEGER PRIMARY KEY,
Sexe CHAR CHECK (sexe='M' OR sexe='F') NOT NULL, Edat INTEGER
);
CREATE TABLE poblacio (
Nom CHAR(30) PRIMARY KEY, Provincia CHAR(10),
Comarca CHAR(15)
);
CREATE TABLE data (
Id DATE PRIMARY KEY,
mes CHAR(8) NOT NULL CHECK (mes IN ('Gener', 'Febrer', 'Marc', 'Abril', 'Maig', 'Juny', 'Juliol', 'Agost', 'Setembre', 'Octubre', 'Novembre', 'Decembre')),
anyo CHAR(4) NOT NULL );
CREATE TABLE especialitat (
Nom CHAR(12) PRIMARY KEY, Tipus CHAR(18)
);
CREATE TABLE rang (
Nom CHAR(13) PRIMARY KEY, Escala CHAR(9)
);
CREATE TABLE destinacio (
PerfilId INTEGER REFERENCES perfil(id),
PoblacioId CHAR(30) REFERENCES poblacio(nom),
dataId DATE REFERENCES data(id),
especialitatId CHAR(12) REFERENCES especialitat(nom),
rangId CHAR(13) REFERENCES rang(nom),
mossos INTEGER,
PRIMARY KEY (perfilId, poblacioId, especialitatId, rangId, dataId) );
INSERT INTO perfil VALUES (1, 'F', 23);
INSERT INTO especialitat VALUES ('Transit','A');
INSERT INTO especialitat VALUES ('Investigacio','B');
INSERT INTO rang VALUES ('Mosso', 'Basica');
INSERT INTO rang VALUES ('Caporal', 'Basica');
INSERT INTO poblacio VALUES ('Badalona', 'Barcelona', 'Barcelones');
INSERT INTO poblacio VALUES ('Hospitalet', 'Barcelona', 'Barcelones');
INSERT INTO poblacio VALUES ('Lleida', 'Lleida', 'Segria');
INSERT INTO poblacio VALUES ('Ponts', 'Lleida', 'Noguera');
INSERT INTO data VALUES ('10/10/2003','Octubre', '2003');
INSERT INTO data VALUES ('10/10/2004','Octubre', '2004');
INSERT INTO destinacio VALUES (1, 'Badalona', '10/10/2003', 'Transit', 'Mosso', 150); INSERT INTO destinacio VALUES (1, 'Badalona', '10/10/2003', 'Transit', 'Caporal', 6); INSERT INTO destinacio VALUES (1, 'Hospitalet', '10/10/2003', 'Transit', 'Mosso', 200); INSERT INTO destinacio VALUES (1, 'Hospitalet', '10/10/2003', 'Transit', 'Caporal', 8); INSERT INTO destinacio VALUES (1, 'Lleida', '10/10/2003', 'Transit', 'Mosso', 201); INSERT INTO destinacio VALUES (1, 'Lleida', '10/10/2003', 'Transit', 'Caporal', 8);
INSERT INTO destinacio VALUES (1, 'Ponts', '10/10/2003', 'Transit', 'Mosso', 50);
INSERT INTO destinacio VALUES (1, 'Ponts', '10/10/2003', 'Transit', 'Caporal', 2);
INSERT INTO destinacio VALUES (1, 'Badalona', '10/10/2004', 'Investigacio', 'Mosso', 200); INSERT INTO destinacio VALUES (1, 'Badalona', '10/10/2004', 'Investigacio', 'Caporal', 20); INSERT INTO destinacio VALUES (1, 'Hospitalet', '10/10/2004', 'Investigacio', 'Mosso', 250); INSERT INTO destinacio VALUES (1, 'Hospitalet', '10/10/2004', 'Investigacio', 'Caporal', 23); INSERT INTO destinacio VALUES (1, 'Lleida', '10/10/2004', 'Investigacio', 'Mosso', 137); INSERT INTO destinacio VALUES (1, 'Lleida', '10/10/2004', 'Investigacio', 'Caporal', 15); INSERT INTO destinacio VALUES (1, 'Ponts', '10/10/2004', 'Investigacio', 'Mosso', 50); INSERT INTO destinacio VALUES (1, 'Ponts', '10/10/2004', 'Investigacio', 'Caporal', 8);
*/

CREATE VIEW nomVista AS
SELECT p.comarca, p.provincia, d.especialitatId, da.anyo, SUM(d.mossos) AS Total
FROM poblacio p, destinacio d, data da
WHERE d.poblacioId = p.nom AND d.dataID = da.id AND da.anyo IN ('2003', '2004') AND
d.especialitatId IN ('Transit', 'Investigacio') AND p.comarca IN ('Barcelones', 'Segria', 'Noguera')
GROUP BY GROUPING SETS (p.comarca, ROLLUP(d.especialitatId, da.anyo), ROLLUP(p.comarca)), (p.provincia);


