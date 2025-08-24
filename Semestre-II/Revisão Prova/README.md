# Resolução

## Questão 1

```sql
INSERT INTO `usuario` (`user_id`, `nome`, `cidade`)
SELECT cliente_id, nome, cidade FROM cliente_antigo
UNION SELECT pessoa_id, nome, cidade FROM pessoa_antigo;

INSERT INTO telefone(telefone.user_id, telefone.fone, telefone.tipo)
SELECT
    cliente_id,
    fone_casa AS fone,
    'CASA' AS tipo
FROM
    cliente_antigo
WHERE
    fone_casa IS NOT NULL AND fone_casa <> ''
UNION
SELECT
    cliente_id,
    fone_trabalho AS fone,
    'TRABALHO' AS tipo
FROM
    cliente_antigo
WHERE
    fone_trabalho IS NOT NULL AND fone_trabalho <> ''
UNION
SELECT
    cliente_id,
    fone_contato AS fone,
    'CONTATO' AS tipo
FROM
    cliente_antigo
WHERE
    fone_contato IS NOT NULL AND fone_contato <> '';
```

## Questão 2

```sql
CREATE VIEW viewFuncProj AS
SELECT funcionario.Pnome, COUNT(trabalha_em.Pnr) AS qtd_projetos, SUM(trabalha_em.Horas) AS qtd_horas FROM funcionario JOIN trabalha_em ON trabalha_em.Fcpf = funcionario.Cpf GROUP BY funcionario.Pnome;

CREATE USER "appFuncProj" IDENTIFIED BY "123";

GRANT SELECT ON viewFuncProj TO "appFuncProj";
```

## Questão 3
```sql
CREATE TABLE funcionarios_projetos SELECT
    funcionario.Pnome AS funcionario,
    COUNT(trabalha_em.Pnr) AS num_projetos,
    SUM(trabalha_em.Horas) AS num_horas
FROM
    funcionario
JOIN trabalha_em ON trabalha_em.Fcpf = funcionario.Cpf
GROUP BY
    funcionario.Pnome;

CREATE VIEW viewFuncionarios_Projetos AS
SELECT * FROM funcionarios_projetos;
```