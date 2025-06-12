# Lista Completa

## 1. Retornar o nome completo (primeiro e último nome concatenados) de todos os funcionários que trabalham mais de 8 horas no projeto "ProdutoX" ou no "ProdutoY" e que tenham mais de um dependente. Os nomes não podem aparecer repetidos e devem estar em ordem alfabética.

```sql
WITH
    num_dependentes AS(
    SELECT
        dependente.Fcpf,
        COUNT(dependente.Fcpf) AS dependentes_funcionarios
    FROM
        dependente
    GROUP BY
        Fcpf
)
SELECT DISTINCT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_funcionario
FROM
    Funcionario
LEFT JOIN trabalha_em ON trabalha_em.Fcpf = funcionario.Cpf
LEFT JOIN num_dependentes ON num_dependentes.Fcpf = funcionario.Cpf
LEFT JOIN projeto ON trabalha_em.Pnr = projeto.Projnumero
WHERE
    projeto.Projnome IN("ProdutoX", "ProdutoY") AND trabalha_em.Horas > 8 AND num_dependentes.dependentes_funcionarios > 1
ORDER BY
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) ASC

```

## 2. Listar o nome do funcionário, seu cpf e seu número de dependentes considerando todos os funcionários que tenham pelo menos 1 dependente do sexo masculino e 1 dependente do sexo feminino.

```sql
WITH
    num_dependentes_m AS(
    SELECT
        dependente.Fcpf,
        COUNT(dependente.Fcpf) AS dependentes_funcionarios_m
    FROM
        dependente
    WHERE
        dependente.Sexo = "M"
    GROUP BY
        Fcpf
),
num_dependentes_f AS(
    SELECT
        dependente.Fcpf,
        COUNT(dependente.Fcpf) AS dependentes_funcionarios_f
    FROM
        dependente
    WHERE
        dependente.Sexo = "F"
    GROUP BY
        Fcpf
)
SELECT DISTINCT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_funcionario,
    funcionario.Cpf,
    (
        num_dependentes_m.dependentes_funcionarios_m + num_dependentes_f.dependentes_funcionarios_f
    ) AS num_dependentes
FROM
    Funcionario
LEFT JOIN num_dependentes_m ON num_dependentes_m.Fcpf = funcionario.Cpf
LEFT JOIN num_dependentes_f ON num_dependentes_f.Fcpf = funcionario.Cpf
WHERE
    num_dependentes_m.dependentes_funcionarios_m >= 1 AND num_dependentes_f.dependentes_funcionarios_f >= 1

```

## 3. Listar o nome e o salário dos funcionários que trabalham no departamento localizado em “Itu”, que tenham nascido na década de 60 e que tenham salário abaixo da média salarial do departamento onde trabalha.

```sql
WITH
    media_salarial_dep AS(
    SELECT
        funcionario.Dnr,
        AVG(funcionario.Salario) AS media_salario
    FROM
        funcionario
    GROUP BY
        funcionario.Dnr
)
SELECT DISTINCT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_funcionario,
    funcionario.Salario
FROM
    funcionario
LEFT JOIN localizacao_dep ON localizacao_dep.Dnumero = funcionario.Dnr
LEFT JOIN media_salarial_dep ON media_salarial_dep.Dnr = funcionario.Dnr
WHERE
    localizacao_dep.Dlocal LIKE "%Itu%" AND funcionario.Datanasc LIKE "%196_-__-__%" AND funcionario.Salario < media_salarial_dep.media_salario

```

## 4. Refazer a questão 3 do exercício anterior sem usar a subconsulta no WHERE.

```sql
SELECT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_funcionario,
    funcionario.Salario
FROM
    funcionario
LEFT JOIN localizacao_dep ON localizacao_dep.Dnumero = funcionario.Dnr
WHERE
    localizacao_dep.Dlocal LIKE "%Itu%" AND funcionario.Datanasc LIKE "%196_-__-__%" AND funcionario.Salario <(
    SELECT
        AVG(ft.Salario)
    FROM
        funcionario AS ft
    WHERE
        ft.Dnr = funcionario.Dnr
);

```

## 5. Refazer a questão 1 do exercício anterior considerando a seleção de funcionários que tenham mais dependentes do que a media de dependentes da empresa.

```sql
WITH
    num_dependentes AS(
    SELECT
        dependente.Fcpf,
        COUNT(dependente.Fcpf) AS dependentes_funcionarios
    FROM
        dependente
    GROUP BY
        Fcpf
)
SELECT DISTINCT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_funcionario
FROM
    Funcionario
LEFT JOIN trabalha_em ON trabalha_em.Fcpf = funcionario.Cpf
LEFT JOIN num_dependentes ON num_dependentes.Fcpf = funcionario.Cpf
LEFT JOIN projeto ON trabalha_em.Pnr = projeto.Projnumero
WHERE
    projeto.Projnome IN("ProdutoX", "ProdutoY") AND trabalha_em.Horas > 8 AND num_dependentes.dependentes_funcionarios > 1 AND num_dependentes.dependentes_funcionarios >(
    SELECT
        COUNT(dependente.Fcpf) / COUNT(funcionario.Cpf)
    FROM
        dependente
    JOIN funcionario ON funcionario.Cpf = dependente.Fcpf
)
ORDER BY
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) ASC


```

## 6. Refazer a questão 1 do exercício anterior considerando a seleção de funcionários que tenham mais dependentes do que a media de dependentes do departamento onde o funcionário trabalha.

```sql
WITH
    num_dependentes AS(
    SELECT
        dependente.Fcpf,
        COUNT(dependente.Fcpf) AS dependentes_funcionarios
    FROM
        dependente
    GROUP BY
        Fcpf
),
num_func_dep AS(
    SELECT
        funcionario.Dnr,
        COUNT(funcionario.Cpf) AS cont
    FROM
        funcionario
    GROUP BY
        funcionario.Dnr
),
media_deps_dep AS(
    SELECT
        funcionario.Dnr,
        (
            COUNT(dependente.Fcpf) / num_func_dep.cont
        ) AS media
    FROM
        dependente
    JOIN funcionario ON funcionario.Cpf = dependente.Fcpf
    JOIN num_func_dep ON num_func_dep.Dnr = funcionario.Dnr
    GROUP BY
        funcionario.Dnr
)
SELECT DISTINCT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_funcionario
FROM
    funcionario
LEFT JOIN trabalha_em ON trabalha_em.Fcpf = funcionario.Cpf
LEFT JOIN num_dependentes ON num_dependentes.Fcpf = funcionario.Cpf
LEFT JOIN projeto ON trabalha_em.Pnr = projeto.Projnumero
LEFT JOIN media_deps_dep ON media_deps_dep.Dnr = funcionario.Dnr
WHERE
    projeto.Projnome IN("ProdutoX", "ProdutoY") AND trabalha_em.Horas > 8 AND num_dependentes.dependentes_funcionarios > 1 AND num_dependentes.dependentes_funcionarios > media_deps_dep.media
ORDER BY
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) ASC

```
