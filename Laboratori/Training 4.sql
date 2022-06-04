/*
Ex. 1
Donat l'esquema adjunt, comproveu si es pot introduir alguna fila en alguna taula (tenint en compte també les restriccions expressades com a vistes materialitzades). Modifiqueu, si cal, la part de l'esquema que conté els "Create Table" eliminant-hi restriccions (el mínim nombre possible, triant amb sentit comú) per tal que es pugui.

Fitxers adjunts:
--assertions.sql
create  materialized view assertion1 as
select 'x' as x from airport a where not exists
    ((select * from expenses e where e.iata2 = a.iata)
    union
    (select * from expenses e where e.iata1 = a.iata));
   
alter table assertion1 add constraint c1 check (x is null);


create  materialized view assertion2 as
select 'x' as x from expenses e1 join expenses e2 ON (e1.iata1 = e2.iata2 and e1.iata2 = e2.iata1);
   
alter table assertion2 add constraint c2 check (x is null);

--tables.sql
CREATE TABLE airport ( 
IATA CHAR(3) PRIMARY KEY, 
city VARCHAR2(25) NOT NULL, 
country VARCHAR2(20) NOT NULL, 
region VARCHAR2(14) NOT NULL constraint A1  CHECK (region IN ('north america', 
'south america', 'caribbean', 'west europe', 'east europe', 
'africa', 'middle east', 'central asia', 'southeast asia', 
'north asia', 'east asia', 'south asia', 'oceania')) 
); 
 
CREATE TABLE expenses ( 
IATA1 CHAR(3)REFERENCES airport, --departure airport 
IATA2 CHAR(3)REFERENCES airport, --destination airport 
fuel NUMBER(8,2) NOT NULL  constraint E3 check (fuel > 0), 
taxes NUMBER(10,2) NOT NULL constraint E4 check (taxes > 0), 
PRIMARY KEY (IATA1, IATA2),
constraint E1 check  (IATA1 = IATA2),
constraint E2 check (fuel > taxes)
); 
 
CREATE TABLE ticket ( 
IATA1 CHAR(3)REFERENCES airport, --departure airport 
IATA2 CHAR(3)REFERENCES airport, --destination airport 
passenger CHAR(10), 
price NUMBER(9,2) constraint  T1 check (price < 0), 
discount INTEGER constraint T2 check (discount > 0), 
PRIMARY KEY (IATA1, IATA2, passenger),
constraint T3 check (price - discount > 0),
constraint T4 check (IATA1 = IATA2),
foreign key (IATA1, IATA2) references expenses
);
*/

CREATE TABLE airport ( 
IATA CHAR(3) PRIMARY KEY, 
city VARCHAR2(25) NOT NULL, 
country VARCHAR2(20) NOT NULL, 
region VARCHAR2(14) NOT NULL constraint A1  CHECK (region IN ('north america', 
'south america', 'caribbean', 'west europe', 'east europe', 
'africa', 'middle east', 'central asia', 'southeast asia', 
'north asia', 'east asia', 'south asia', 'oceania')) 
); 
 
CREATE TABLE expenses ( 
IATA1 CHAR(3)REFERENCES airport, --departure airport 
IATA2 CHAR(3)REFERENCES airport, --destination airport 
fuel NUMBER(8,2) NOT NULL  constraint E3 check (fuel > 0), 
taxes NUMBER(10,2) NOT NULL constraint E4 check (taxes > 0), 
PRIMARY KEY (IATA1, IATA2),
constraint E2 check (fuel > taxes)
); 
 
CREATE TABLE ticket ( 
IATA1 CHAR(3)REFERENCES airport, --departure airport 
IATA2 CHAR(3)REFERENCES airport, --destination airport 
passenger CHAR(10), 
price NUMBER(9,2) constraint  T1 check (price < 0), 
discount INTEGER constraint T2 check (discount > 0), 
PRIMARY KEY (IATA1, IATA2, passenger),
constraint T3 check (price - discount > 0),
constraint T4 check (IATA1 = IATA2),
foreign key (IATA1, IATA2) references expenses
);


/*
Ex. 2
A partir de la solució de la pregunta anterior (però tenint en compte també les restriccions expressades com a vistes materialitzades), penseu si ara es poden inserir tuples a totes les taules o només en algunes. Modifiqueu, si cal, la part de l'esquema corresponent als "Create Table" eliminant-hi restriccions (el mínim nombre possible, triant amb sentit comú) per poder fer insercions a totes les taules.
*/

CREATE TABLE airport ( 
IATA CHAR(3) PRIMARY KEY, 
city VARCHAR2(25) NOT NULL, 
country VARCHAR2(20) NOT NULL, 
region VARCHAR2(14) NOT NULL constraint A1  CHECK (region IN ('north america', 
'south america', 'caribbean', 'west europe', 'east europe', 
'africa', 'middle east', 'central asia', 'southeast asia', 
'north asia', 'east asia', 'south asia', 'oceania')) 
); 
 
CREATE TABLE expenses ( 
IATA1 CHAR(3)REFERENCES airport, --departure airport 
IATA2 CHAR(3)REFERENCES airport, --destination airport 
fuel NUMBER(8,2) NOT NULL  constraint E3 check (fuel > 0), 
taxes NUMBER(10,2) NOT NULL constraint E4 check (taxes > 0), 
PRIMARY KEY (IATA1, IATA2),
constraint E2 check (fuel > taxes)
); 
 
CREATE TABLE ticket ( 
IATA1 CHAR(3)REFERENCES airport, --departure airport 
IATA2 CHAR(3)REFERENCES airport, --destination airport 
passenger CHAR(10), 
price NUMBER(9,2) constraint  T1 check (price < 0), 
discount INTEGER constraint T2 check (discount > 0), 
PRIMARY KEY (IATA1, IATA2, passenger),
constraint T3 check (price - discount > 0),
foreign key (IATA1, IATA2) references expenses
);


/*
Ex. 3
A partir de la solució de la pregunta anterior (però tenint en compte també les restriccions expressades com a vistes materialitzades), pensa si la vista adjunta té la propietat de liveliness. En cas afirmatiu, proposa uns INSERT (el mínim nombre possible) d'exemple. En cas negatiu, no responguis a través del corrector; justifica la resposta en paper.

Fitxers adjunts:
create view TE as select t.iata1, t.iata2 from ticket t where 50 * t.discount >
    (select e.fuel + e.taxes from expenses e where e.iata1 = t.iata1 and e.iata2 = t.iata2)
*/

INSERT INTO AIRPORT VALUES ('b', 'b', 'c','west europe');
INSERT INTO AIRPORT VALUES ('c', 'a', 'a','west europe');
INSERT INTO EXPENSES values('b', 'c', 8, 2);
INSERT INTO TICKET values('b', 'c', 'andreu',null, 10);


/*
Ex. 4
Donades la taula i les dades al fitxer adjunt, feu el disseny físic de manera que sigui òptima l'execució de la consulta següent:

SELECT sum(pressupost) from obres where id = 500;

Es imprescindible que abans d'iniciar la correcció t'aseguris de:
Només hi ha d'haver al teu espai els objectes corresponents a aquest enunciat.
Buidar completament la paperera de reciclatge ("PURGE RECYCLEBIN").
Actualitzar les estadísitiques de tots els objectes (fes servir el bloc de codi que tens al fitxer adjunt).

Fitxers adjunts:
create table obres(
 id  number(8,0),
 zona char(20),
 tipus  number(17,0),
 pressupost number(17, 0),
 nom char(100),
 empreses char(250),
 descripcio char(250),
 responsables char(250)
);


DECLARE id int;
pn int;
i int;
nz INT;
zona CHAR(20);
tipus INT;

begin
pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix VallËs'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'VallËs Orient'; END if;
	if (nz = 6) then zona := 'VallËs Occident'; END if;
	if (nz = 7) then zona := 'MoianËs'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
	insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;

-- Actualitzar estadÌstiques
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';
BEGIN
SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
FOR taula IN c LOOP
  DBMS_STATS.GATHER_TABLE_STATS( 
    ownname => esquema, 
    tabname => taula.table_name, 
    estimate_percent => NULL,
    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
    granularity => 'GLOBAL',
    cascade => TRUE
    );
  END LOOP;
END;
*/

Hash Obres(id)

/*
Ex. 5
Donades la taula i les dades al fitxer adjunt, feu el disseny físic de manera que sigui òptima l'execució de la consulta següent:

SELECT sum(pressupost) from obres where id > 5 and id < 800;

Es imprescindible que abans d'iniciar la correcció t'aseguris de:
Només hi ha d'haver al teu espai els objectes corresponents a aquest enunciat.
Buidar completament la paperera de reciclatge ("PURGE RECYCLEBIN").
Actualitzar les estadísitiques de tots els objectes (fes servir el bloc de codi que tens al fitxer adjunt).

Fitxer adjunt:
create table obres(
 id  number(8,0),
 zona char(20),
 tipus  number(17,0),
 pressupost number(17, 0),
 nom char(100),
 empreses char(250),
 descripcio char(250),
 responsables char(250)
);


DECLARE id int;
pn int;
i int;
nz INT;
zona CHAR(20);
tipus INT;

begin
pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix VallËs'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'VallËs Orient'; END if;
	if (nz = 6) then zona := 'VallËs Occident'; END if;
	if (nz = 7) then zona := 'MoianËs'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
	insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;

-- Actualitzar estadÌstiques
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';
BEGIN
SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
FOR taula IN c LOOP
  DBMS_STATS.GATHER_TABLE_STATS( 
    ownname => esquema, 
    tabname => taula.table_name, 
    estimate_percent => NULL,
    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
    granularity => 'GLOBAL',
    cascade => TRUE
    );
  END LOOP;
END;
*/

Sense índex


/*
Ex. 6
Donades la taula i les dades al fitxer adjunt, feu el disseny físic de manera que sigui òptima l'execució de la consulta següent SENSE OCUPAR MÉS DE 150 BLOCS (arrodoniu l'espai per fila a múltiples de 1k):

SELECT sum(pressupost) from obres where id >= 5 and id <= 10;

Es imprescindible que abans d'iniciar la correcció t'aseguris de:
Només hi ha d'haver al teu espai els objectes corresponents a aquest enunciat.
Buidar completament la paperera de reciclatge ("PURGE RECYCLEBIN").
Actualitzar les estadísitiques de tots els objectes (fes servir el bloc de codi que tens al fitxer adjunt).

Fitxer adjunt:
create table obres(
 id  number(8,0),
 zona char(20),
 tipus  number(17,0),
 pressupost number(17, 0),
 nom char(100),
 empreses char(250),
 descripcio char(250),
 responsables char(250)
);


DECLARE id int;
pn int;
i int;
nz INT;
zona CHAR(20);
tipus INT;

begin
pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix VallËs'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'VallËs Orient'; END if;
	if (nz = 6) then zona := 'VallËs Occident'; END if;
	if (nz = 7) then zona := 'MoianËs'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
	insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;

-- Actualitzar estadÌstiques
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';
BEGIN
SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
FOR taula IN c LOOP
  DBMS_STATS.GATHER_TABLE_STATS( 
    ownname => esquema, 
    tabname => taula.table_name, 
    estimate_percent => NULL,
    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
    granularity => 'GLOBAL',
    cascade => TRUE
    );
  END LOOP;
END;
*/

Unique B+ Obres(id)

/*
Ex. 7
Donades la taula i les dades al fitxer adjunt, feu el disseny físic de manera que sigui òptima l'execució de la consulta següent:

select sum(o.pressupost), sum(p.pressupost)
from obres o, projectes p
where o.proj = p.id and p.id = 50;

Es imprescindible que abans d'iniciar la correcció t'aseguris de:
Només hi ha d'haver al teu espai els objectes corresponents a aquest enunciat.
Buidar completament la paperera de reciclatge ("PURGE RECYCLEBIN").
Actualitzar les estadísitiques de tots els objectes (fes servir el bloc de codi que tens al fitxer adjunt).

Fitxer adjunt:
create table projectes(
 id  number(8,0),
 zona char(20),
 pressupost number(17, 0),
 nom char(100),
  descripcio char(250),
  qual_mediamb char(250)
 );
 
create table obres(
 id  number(8,0),
 proj number(8, 0),
  tipus  number(17,0),
 pressupost number(17, 0),
 empreses char(250),
 responsables char(250)
);

DECLARE id INT; pn INT; i INT;
nz INT;
zona CHAR(20);
tipus INT;
proj int;

begin

for i in 1..100 loop
  	nz := (i - 1) Mod 10 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix Vall?s'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'Vall?s Orient'; END if;
	if (nz = 6) then zona := 'Vall?s Occident'; END if;
	if (nz = 7) then zona := 'Moian?s'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
        insert into projectes values(i, zona, 20000, 'nom' || i, 'descr' || i, 'qual' || i);
end loop;


pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
        proj := (id - 1) mod 100 + 1;
	insert into obres values (id, proj, tipus, 1000, 'emp' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;


-- Actualitzar estadÌstiques
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';
BEGIN
SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
FOR taula IN c LOOP
  DBMS_STATS.GATHER_TABLE_STATS( 
    ownname => esquema, 
    tabname => taula.table_name, 
    estimate_percent => NULL,
    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
    granularity => 'GLOBAL',
    cascade => TRUE
    );
  END LOOP;
END;
*/

Hash Projectes(id)
Hash Obres(proj)


/*
Ex. 8
Donades la taula i les dades al fitxer adjunt, feu el disseny físic de manera que sigui òptima l'execució de la consulta següent:

select sum(o.pressupost), sum(p.pressupost)
from obres o, projectes p
where o.proj = p.id and p.id >95;

Es imprescindible que abans d'iniciar la correcció t'aseguris de:
Només hi ha d'haver al teu espai els objectes corresponents a aquest enunciat.
Buidar completament la paperera de reciclatge ("PURGE RECYCLEBIN").
Actualitzar les estadísitiques de tots els objectes (fes servir el bloc de codi que tens al fitxer adjunt).

Fitxer adjunt:
create table projectes(
 id  number(8,0),
 zona char(20),
 pressupost number(17, 0),
 nom char(100),
  descripcio char(250),
  qual_mediamb char(250)
 );
 
create table obres(
 id  number(8,0),
 proj number(8, 0),
  tipus  number(17,0),
 pressupost number(17, 0),
 empreses char(250),
 responsables char(250)
);

DECLARE id INT; pn INT; i INT;
nz INT;
zona CHAR(20);
tipus INT;
proj int;

begin

for i in 1..100 loop
  	nz := (i - 1) Mod 10 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix Vall?s'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'Vall?s Orient'; END if;
	if (nz = 6) then zona := 'Vall?s Occident'; END if;
	if (nz = 7) then zona := 'Moian?s'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
        insert into projectes values(i, zona, 20000, 'nom' || i, 'descr' || i, 'qual' || i);
end loop;


pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
        proj := (id - 1) mod 100 + 1;
	insert into obres values (id, proj, tipus, 1000, 'emp' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;


-- Actualitzar estadÌstiques
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';
BEGIN
SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
FOR taula IN c LOOP
  DBMS_STATS.GATHER_TABLE_STATS( 
    ownname => esquema, 
    tabname => taula.table_name, 
    estimate_percent => NULL,
    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
    granularity => 'GLOBAL',
    cascade => TRUE
    );
  END LOOP;
END;
*/

Índex Cluster Projectes(id)
Hash Obres(proj)




