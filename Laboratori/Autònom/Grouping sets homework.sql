/*
Ex.1
Utilitzant les clàusules del SQL'99 específiques per consultes multidimensionals, i l'esquema en estrella que pots trobar al fitxer adjunt (que representa la història de tots els mossos de tota Catalunya), creeu una vista que porti per nom "nomVista" que correspongui a la taula estadística següent:

[taula]

La taula conté pels anys 2003 i 2004, la suma (d'entre tots els perfils) de mossos de les especialitats 'Transit' i 'Investigacio' que hi ha assignats, a les poblacions de Badalona, Hospitalet, Lleida i Ponts, i amb el rang de Caporal i Mosso. Poseu al SELECT els atributs del nom de la poblacio, especialitat i rang, seguits per la suma de la mesura, exactament en aquest ordre. No cal que rescribiu els valors nuls de la sortida com a 'Total' i no poseu ORDER BY, perque les vistes no ho accepten.

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
SELECT d.poblacioId AS Poblacio, d.especialitatId AS Especialitat, d.rangId AS Rang, SUM(d.mossos) AS Total
FROM DESTINACIO d, DATA da
WHERE d.dataId = da.id AND da.anyo IN ('2003', '2004') AND d.poblacioId IN ('Badalona', 'Hospitalet', 'Lleida', 'Ponts')
AND d.rangId IN ('Caporal', 'Mosso') AND d.especialitatId IN ('Transit', 'Investigacio')
GROUP BY CUBE (d.especialitatId, d.poblacioId, d.rangId);


/*
Ex. 2
Utilitzant les clàusules del SQL'99 específiques per consultes multidimensionals més escaients i l'esquema en estrella que pots trobar al fitxer adjunt (que representa la història de tots els mossos de tota Catalunya), creeu una vista que porti per nom "nomVista" que correspongui a la taula estadística següent:

[table]

La taula conté per l'any 2003, la suma (d'entre tots els perfils i rangs) de mossos de l'especialitat "Transit" i "Investigacio" que hi ha assignats, a les poblacions de Badalona, Hospitalet, Lleida i Ponts. Poseu al SELECT els atributs del nom de la poblacio, comarca, provincia i especialitat, seguits de la suma de la mesura, exactament en aquest ordre. No cal que rescribiu els valors nuls de la sortida com a 'Total' i no poseu ORDER BY, perque les vistes no ho accepten.

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
SELECT p.nom AS Poblacio, p.comarca AS Comarca, p.provincia AS Provincia, d.especialitatId AS Especialitat, SUM(d.mossos) AS Total
FROM DESTINACIO d, DATA da, POBLACIO p
WHERE d.poblacioId = p.nom AND d.dataId = da.id AND da.anyo IN ('2003') AND p.nom IN ('Badalona', 'Hospitalet', 'Lleida', 'Ponts') AND d.especialitatID IN ('Transit', 'Investigacio')
GROUP BY ROLLUP (p.provincia, p.comarca, p.nom), (d.especialitatId);
