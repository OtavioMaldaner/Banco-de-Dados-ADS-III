# Lista Revisão Subqueries

## 1. Liste os nomes dos funcionários que recebem salário maior que o salário do funcionário chamado 'João'.

```sql
WITH
    salario_joao AS(
    SELECT
        funcionario.Salario
    FROM
        funcionario
    WHERE
        funcionario.Pnome LIKE "%João%"
)
SELECT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_completo
FROM
    funcionario
WHERE
    funcionario.Salario >=(
    SELECT
        salario_joao.Salario
    FROM
        salario_joao
)
```

## 2. Mostre o nome e salário dos funcionários cujo salário seja maior que a média salarial do departamento 'Administração'.

```sql
WITH
    media_salario_adm AS(
    SELECT
        AVG(funcionario.Salario) AS media_salario
    FROM
        funcionario
    JOIN departamento ON funcionario.Dnr = departamento.Dnumero
    WHERE
        departamento.Dnome LIKE "%Administração%"
    GROUP BY
        funcionario.Dnr
)
SELECT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_completo,
    funcionario.Salario
FROM
    funcionario
WHERE
    funcionario.Salario >=(
    SELECT
        media_salario_adm.media_salario
    FROM
        media_salario_adm
)
```

## 3. Exiba o nome dos departamentos cujo número de funcionários é igual ao número de projetos que ele gerencia.

```sql
WITH
    num_funcionarios AS(
    SELECT
        funcionario.Dnr,
        COUNT(funcionario.Cpf) AS contagem_funcionarios
    FROM
        funcionario
    GROUP BY
        funcionario.Dnr
),
num_projetos AS(
    SELECT
        projeto.Dnum,
        COUNT(projeto.Projnumero) AS contagem_projetos
    FROM
        projeto
    GROUP BY
        projeto.Dnum
)
SELECT
    departamento.Dnome
FROM
    departamento
JOIN num_funcionarios ON departamento.Dnumero = num_funcionarios.Dnr
JOIN num_projetos ON departamento.Dnumero = num_projetos.Dnum
WHERE
    contagem_funcionarios = contagem_projetos
```

## 4. Exibir os nomes dos projetos nos quais não há nenhum funcionário que tenha o mesmo sobrenome que o gerente do departamento do projeto.

```sql
WITH
    sobrenome_supervisor AS(
    SELECT
        departamento.Dnumero,
        funcionario.Unome AS sobrenome_supervisor
    FROM
        departamento
    JOIN funcionario ON funcionario.Cpf = departamento.Cpf_gerente
    GROUP BY
        departamento.Dnumero
)
SELECT DISTINCT
    projeto.Projnome
FROM
    projeto
JOIN trabalha_em ON trabalha_em.Pnr = projeto.Projnumero
JOIN funcionario ON funcionario.Cpf = trabalha_em.Fcpf
JOIN sobrenome_supervisor ON sobrenome_supervisor.Dnumero = funcionario.Dnr
WHERE
    projeto.Projnome NOT IN(
    SELECT
        projeto.Projnome
    FROM
        projeto
    JOIN trabalha_em ON trabalha_em.Pnr = projeto.Projnumero
    JOIN funcionario ON funcionario.Cpf = trabalha_em.Fcpf
    JOIN sobrenome_supervisor ON sobrenome_supervisor.Dnumero = funcionario.Dnr
    WHERE
        funcionario.Unome = sobrenome_supervisor
)
```

## 5. Mostre os nomes dos funcionários que trabalham nos mesmos projetos que o funcionário chamado 'Alice', mas que não sejam a própria Alice.

```sql
WITH
    projetos_alice AS(
    SELECT DISTINCT
        trabalha_em.Pnr
    FROM
        trabalha_em
    JOIN funcionario ON funcionario.Cpf = trabalha_em.Fcpf
    WHERE
        funcionario.Pnome LIKE "%Alice%"
)
SELECT DISTINCT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_funcionario
FROM
    funcionario
JOIN trabalha_em ON funcionario.Cpf = trabalha_em.Fcpf
JOIN projetos_alice ON projetos_alice.Pnr = trabalha_em.Pnr
WHERE
    funcionario.Pnome NOT LIKE "%Alice%"
```

## 6. Liste o nome dos funcionários que trabalham nos mesmos projetos e com a mesma carga horária que outro funcionário chamado 'Fernando'.

```sql
WITH
    projetos_fernando AS(
    SELECT
        trabalha_em.Pnr,
        trabalha_em.Horas
    FROM
        trabalha_em
    JOIN funcionario ON funcionario.Cpf = trabalha_em.Fcpf
    WHERE
        funcionario.Pnome LIKE "%Fernando%"
)
SELECT DISTINCT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_funcionario
FROM
    funcionario
JOIN trabalha_em ON funcionario.Cpf = trabalha_em.Fcpf
JOIN projetos_fernando ON projetos_fernando.Pnr = trabalha_em.Pnr
WHERE
    trabalha_em.Horas <> projetos_fernando.Horas
```
