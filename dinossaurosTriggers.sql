create database dinossauros_triggers;

create table regioes (
	id serial primary key,
	nome varchar(60) not null
);

create table grupos (
	id serial primary key,
	nome varchar(30) not null
);

create table eras (
	id serial primary key,
	nome varchar(30) not null,
	inicio_duracao int not null,
	fim_duracao int not null	
);

create table descobridores (
	id serial primary key,
	nome varchar(100) not null
);

create table dinossauros (
	id serial primary key,
	nome varchar(100) not null,
	toneladas integer not null,
	ano_descoberta integer not null,
	fk_grupo integer,
	fk_era integer,
	fk_regiao integer,
	fk_descobridor integer,
	inicio integer,
	fim integer,
	foreign key (fk_grupo) references grupos(id),
	foreign key (fk_era) references eras(id),
	foreign key (fk_regiao) references regioes(id),
	foreign key (fk_descobridor) references descobridores(id)	
);

select * from regioes;
select * from grupos;
select * from eras;
select * from descobridores;
select * from dinossauros;

insert into regioes (nome) values ('Mongólia'), ('Canadá'), ('Tanzânia'), 
	('China'), ('America do Norte'), ('USA');

insert into grupos (nome) values ('Anquilossauros'), ('Ceratopsídeos'), ('Estegossauros'), 
	('Terápodes');

insert into eras (nome,inicio_duracao, fim_duracao ) values ('Triássico', 251, 200), ('Jurássico', 200, 145), 
	('Cretáceo', 145, 65);

insert into descobridores (nome) values ('Maryanska'), ('John Bell Hatcher'), ('Cinetistas Alemãs'), 
	('Museu Americano de História Natural'), ('Othniel Charles Marsh'), ('Barnum Brown');

-- Criação da função de trigger 
CREATE OR REPLACE FUNCTION verifica_era_dinossauro()
RETURNS TRIGGER AS $BODY$
DECLARE
    era_inicio_duracao INT := 0; 
    era_fim_duracao INT := 0;    
BEGIN
    SELECT inicio_duracao, fim_duracao
    INTO era_inicio_duracao, era_fim_duracao
    FROM eras
    WHERE id = NEW.fk_era;    
    IF (NEW.inicio < era_inicio_duracao OR NEW.fim > era_fim_duracao) THEN
        RAISE EXCEPTION 'O período informado (% - %) não está dentro da duração permitida para a era %.', 
                        NEW.inicio, NEW.fim, NEW.fk_era;
    END IF;
				RAISE NOTICE 'validação bem-sucedida, inserção permitida';   
    RETURN NEW;
END;
$BODY$ 
	LANGUAGE plpgsql VOLATILE;

-- Criação da trigger
CREATE TRIGGER trigger_verifica_era_dinossauro
AFTER INSERT 
	ON dinossauros
FOR EACH ROW EXECUTE PROCEDURE verifica_era_dinossauro();



insert into dinossauros(nome, toneladas, ano_descoberta, fk_grupo, fk_era, fk_regiao, fk_descobridor, inicio, fim) values 
	
	
	('Tricerátops', 6, 1887,2, 3, 2, 2, 70, 66) -- validação negada ok, conforme esperado	
	('Kentrossauro', 2, 1909, 3, 2, 3, 3, 200, 145) -- validação ok
	
	

-- Dados separados para ir testando
	('Saichania', 4, 1977, 1, 3, 1, 1, 145, 66),
	('Tricerátops', 6, 1887,2, 3, 2, 2, 70, 66),
	('Kentrossauro', 2, 1909, 3, 2, 3, 3, 200, 145),
	('Pinacossauro', 6, 1999, 1, 1, 4, 4, 85, 75),
	('Alossauro', 3, 1877,4, 2, 5, 6, 155, 150),
	('Torossauro', 8, 1891, 2, 3, 6, 2, 67, 65),
	('Anquilossauro', 8, 1906, 1, 1, 5, 6, 66, 63);