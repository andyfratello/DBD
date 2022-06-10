-- Sentències de preparació de la base de dades:
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
-- Joc de proves Públic
--------------------------

-- Sentències d'inicialització:
insert into bolets values ('mataparents', 'N', 0); 
insert into bolets values ('llanega negra', 'S', 10); 
insert into bolets values ('cep', 'S', 10); 

insert into boletaires values ('Pep', 538, null, 21); 

insert into troballes values ('Pep', 'llanega negra', 4, 12, 'Cadi');



















