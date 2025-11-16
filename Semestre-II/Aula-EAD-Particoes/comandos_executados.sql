CREATE TABLE `pessoa_range` (
  `pessoa_id` smallint(5) UNSIGNED NOT NULL,
  `nome` varchar(45) NOT NULL,
  `endereco` varchar(50) NOT NULL,
  `distrito` varchar(20) NOT NULL,
  `cidade` varchar(50) NOT NULL,
  `cep` varchar(10) DEFAULT NULL,
  `pais` varchar(50) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`pessoa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
PARTITION BY RANGE (pessoa_id) (
    PARTITION p0 VALUES LESS THAN (50),
    PARTITION p1 VALUES LESS THAN (100),
    PARTITION p2 VALUES LESS THAN (150),
    PARTITION p3 VALUES LESS THAN MAXVALUE
);

INSERT INTO `pessoa_range` SELECT * FROM `pessoa`;

CREATE TABLE `pessoaold_list` (
  `pessoa_id` smallint(5) UNSIGNED NOT NULL,
  `nome` varchar(45) NOT NULL,
  `tipo_pessoa` varchar(2) NOT NULL,
  `cpf_cnpj` int(11) NOT NULL,
  `rg_inscricao_estadual` int(11) NOT NULL,
  `fone` varchar(20) NOT NULL,
  `endereco` varchar(50) NOT NULL,
  `distrito` varchar(20) NOT NULL,
  `cidade` varchar(50) NOT NULL,
  `cep` varchar(10) DEFAULT NULL,
  `pais` varchar(50) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`pessoa_id`, `tipo_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY LIST COLUMNS(tipo_pessoa) (
    PARTITION p_pf VALUES IN ('PF'),
    PARTITION p_pj VALUES IN ('PJ')
);

INSERT INTO `pessoaold_list` SELECT * FROM `pessoaold`;

CREATE TABLE `pessoa_hash` (
  `pessoa_id` smallint(5) UNSIGNED NOT NULL,
  `nome` varchar(45) NOT NULL,
  `endereco` varchar(50) NOT NULL,
  `distrito` varchar(20) NOT NULL,
  `cidade` varchar(50) NOT NULL,
  `cep` varchar(10) DEFAULT NULL,
  `pais` varchar(50) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`pessoa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
PARTITION BY HASH (pessoa_id)
PARTITIONS 4;

INSERT INTO `pessoa_hash` SELECT * FROM `pessoa`;

CREATE TABLE `pessoa_key` (
  `pessoa_id` smallint(5) UNSIGNED NOT NULL,
  `nome` varchar(45) NOT NULL,
  `endereco` varchar(50) NOT NULL,
  `distrito` varchar(20) NOT NULL,
  `cidade` varchar(50) NOT NULL,
  `cep` varchar(10) DEFAULT NULL,
  `pais` varchar(50) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`pessoa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
PARTITION BY KEY ()
PARTITIONS 4;

INSERT INTO `pessoa_key` SELECT * FROM `pessoa`;