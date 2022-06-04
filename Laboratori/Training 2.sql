/*
QÜESTIÓ 1
Traduïu a model relacional l'esquema conceptual que trobareu al fitxer adjunt. Trieu la traducció que requereixi menys espai.

Considereu que, donat que l'esplai permet portar mascotes, gairebé tots els nens en portarán. A més, penseu que no te sentit enregistrar que un noi es amic d'ell mateix o que una mascota es incompatible amb ella mateixa.

La solució han de ser els CREATE TABLE necessaris. Recolliu-hi totes les restriccions que pogueu. No us descuideu dels NOT NULL que calgui segons la traducció a relacional (i només aquests) ni de declarar les claus alternatives amb UNIQUE i NOT NULL.

*/

CREATE TABLE Grup (
 nom varchar(1) ,
 monitor varchar(1) ,
 CONSTRAINT Grup_PK PRIMARY KEY (nom));
 
 CREATE TABLE Noi (
 Grup_nom varchar(1)  NOT NULL,
 nom varchar(1) ,
 edat varchar(1) ,
 Mascota_nom varchar(1),
 CONSTRAINT Noi_FK_Grup FOREIGN KEY (Grup_nom) REFERENCES Grup(nom),
 CONSTRAINT Noi_PK PRIMARY KEY (nom),
 CONSTRAINT Noi_UNIQUE UNIQUE (Mascota_nom));
 
 CREATE TABLE Amics (
 Noi1_nom varchar(1) NOT NULL,
 Noi2_nom varchar(1) NOT NULL,
 CONSTRAINT Amics1_FK_Noi FOREIGN KEY (Noi1_nom) REFERENCES Noi(nom),
 CONSTRAINT Amics2_FK_Noi FOREIGN KEY (Noi2_nom) REFERENCES Noi(nom),
 CONSTRAINT Amics_PK PRIMARY KEY (Noi1_nom, Noi2_nom),
CONSTRAINT Amics_check CHECK(Noi1_nom<>Noi2_nom));
 
 CREATE TABLE Incompatibles (
 Mascota1_nom varchar(1) NOT NULL,
 Mascota2_nom varchar(1) NOT NULL,
 CONSTRAINT Incompatibles1_FK_Mascota FOREIGN KEY (Mascota1_nom) REFERENCES Noi(Mascota_nom),
 CONSTRAINT Incompatibles2_FK_Mascota FOREIGN KEY (Mascota2_nom) REFERENCES Noi(Mascota_nom),
 CONSTRAINT Incompatibles_PK PRIMARY KEY (Mascota1_nom, Mascota2_nom),
CONSTRAINT incompatibles_check CHECK (Mascota1_nom<>Mascota2_nom) );


/*
QÜESTIÓ 2
Traduïu a model relacional l'esquema conceptual que trobareu al fitxer adjunt. Procureu, en primera instància, evitar valors nuls. Si queden diverses alternatives, trieu la que requereixi menys espai.

Els esplais organitzen els nois en grups anomenats tandes. Els nois només poden anar a sortides de les seves tandes i les sortides de cada tanda han de formar part del calendari de la tanda.

La solució han de ser els CREATE TABLE necessaris. Recolliu-hi totes les restriccions que pogueu. No us descuideu dels NOT NULL que calgui segons la traducció a relacional (i només aquests) ni de declarar les claus alternatives amb UNIQUE i NOT NULL.
*/


CREATE TABLE Esplai
(
    Nom VARCHAR (1),
    Adreca VARCHAR (1),
    CONSTRAINT PK_Esplai PRIMARY KEY (Nom)
);


CREATE TABLE Jornada
(
    Data VARCHAR (1),
    SortSol VARCHAR (1),
    PostaSol VARCHAR (1),
    CONSTRAINT PK_Jornada PRIMARY KEY (Data)
);


CREATE TABLE Noi
(
    Nom VARCHAR (1),
    Cognom1 VARCHAR (1),
    Cognom2 VARCHAR (1),
    Edat VARCHAR (1),
    CONSTRAINT PK_Noi PRIMARY KEY (Cognom1, Cognom2, Nom)
);


CREATE TABLE Tanda
(
    Nom VARCHAR (1),
    Ident VARCHAR (1),
    CONSTRAINT PK_Tanda PRIMARY KEY (Nom, Ident),
    CONSTRAINT FK_Tanda_0 FOREIGN KEY (Nom) REFERENCES Esplai (Nom) ON DELETE CASCADE
);


CREATE TABLE Membre
(
    Nom VARCHAR (1),
    Ident VARCHAR (1),
    Cognom1 VARCHAR (1),
    Cognom2 VARCHAR (1),
    NomNoi VARCHAR (1),
    CONSTRAINT PK_Membre PRIMARY KEY (Nom, Ident, Cognom1, Cognom2, NomNoi),
    CONSTRAINT FK_Membre_0 FOREIGN KEY (Nom, Ident) REFERENCES Tanda (Nom, Ident) ON DELETE CASCADE,
    CONSTRAINT FK_Membre_1 FOREIGN KEY (Cognom1, Cognom2, NomNoi) REFERENCES Noi (Cognom1, Cognom2, Nom) ON DELETE CASCADE
);


CREATE TABLE Calendari
(
    Nom VARCHAR (1),
    Ident VARCHAR (1),
    Data VARCHAR (1),
    CONSTRAINT PK_Calendari PRIMARY KEY (Nom, Ident, Data),
    CONSTRAINT FK_Calendari_0 FOREIGN KEY (Nom, Ident) REFERENCES Tanda (Nom, Ident) ON DELETE CASCADE,
    CONSTRAINT FK_Calendari_1 FOREIGN KEY (Data) REFERENCES Jornada (Data) ON DELETE CASCADE
);


CREATE TABLE Sortida
(
    Data VARCHAR (1),
    Nom VARCHAR (1) NOT NULL,
    Ident VARCHAR (1) NOT NULL,
    Cognom1 VARCHAR (1),
    Cognom2 VARCHAR (1),
    NomNoi VARCHAR (1),
    CONSTRAINT PK_Sortida PRIMARY KEY (Data, Cognom1, Cognom2, NomNoi),
    -- CONSTRAINT FK_Sortida_0 FOREIGN KEY (Data) REFERENCES Jornada (Data) ON DELETE CASCADE,
   --  CONSTRAINT FK_Sortida_1 FOREIGN KEY (Nom, Ident) REFERENCES Tanda (Nom, Ident) ON DELETE CASCADE,
   --  CONSTRAINT FK_Sortida_2 FOREIGN KEY (Cognom1, Cognom2, NomNoi) REFERENCES Noi (Cognom1, Cognom2, Nom) ON DELETE CASCADE,
CONSTRAINT SortidesSOnACalendari FOREIGN KEY (Nom, Ident, Data) REFERENCES calendari(Nom, Ident, Data),
CONSTRAINT SortidesSOnATanda FOREIGN KEY (Nom, Ident, Cognom1, Cognom2, NomNoi) REFERENCES membre(Nom, Ident, Cognom1, Cognom2, NomNoi)
);

