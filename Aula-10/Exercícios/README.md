# Lista 1

## 1. Recuperar o nome dos funcionários que tem salário maior que ‘30.000’.

```sql
SELECT
    funcionario.Pnome,
    funcionario.Salario
FROM
    funcionario
WHERE
	funcionario.Salario >= 30000
```

## 2. Recuperar o nome dos funcionários que tem salário menor que ‘30.000’ e que seja do sexo feminino.

```sql
SELECT
    funcionario.Pnome,
    funcionario.Salario
FROM
    funcionario
WHERE
	funcionario.Salario < 30000
    AND funcionario.Sexo = "F"
```

## 3. Listar a soma total dos salários por sexo.

```sql
SELECT
    funcionario.Sexo,
    SUM(funcionario.Salario)
FROM
    funcionario
GROUP BY
	Sexo
```

## 4. Listar o menor, o maior e a média dos salários por departamento.

```sql
SELECT
    funcionario.Dnr,
    MIN(funcionario.Salario),
    MAX(funcionario.Salario),
    AVG(funcionario.Salario)
FROM
    funcionario
GROUP BY
	Dnr
```

## 5. Retornar a quantidade de dependentes por sexo.

```sql
SELECT
    dependente.Sexo,
    COUNT(dependente.Sexo)
FROM
    dependente
GROUP BY
	Sexo
```

## 6. Retornar a quantidade de dependentes por sexo do funcionário.

```sql
SELECT
    funcionario.Sexo,
    COUNT(dependente.Fcpf)
FROM
    funcionario
LEFT JOIN
	dependente
ON dependente.Fcpf = funcionario.Cpf
GROUP BY
	Sexo
```

## 7. Recuperar o nome e o endereço de todos os funcionários que trabalham para o departamento de ‘Pesquisa’.

```sql
SELECT
    funcionario.Pnome,
    funcionario.Endereco
FROM
    funcionario
LEFT JOIN departamento
ON departamento.Dnumero = funcionario.Dnr
WHERE departamento.Dnome = "Pesquisa"
```

# Lista 2

## 1. Fazer uma lista dos números de projeto nos quais trabalham funcionários cujo último nome seja ‘Silva’. A lista também deve conter os números dos projetos que pertencem ao departamento “Pesquisa”. Uso obrigatório de UNION ou UNION ALL para apresentar os números dos projetos, considerando que eles não devem aparecer de forma repetida.

```sql
SELECT
    projeto.Projnumero
FROM
    projeto
LEFT JOIN funcionario ON funcionario.Dnr = projeto.Dnum
WHERE
    funcionario.Unome LIKE "%Silva%"
UNION
SELECT
    projeto.Projnumero
FROM
    projeto
LEFT JOIN departamento ON departamento.Dnumero = projeto.Dnum
WHERE
    departamento.Dnome = "Pesquisa"
```

## 2. Encontre o nome de todos os funcionários que nasceram entre '1960-01-01' AND '1969-12-31'. Uso obrigatório do BETWEEN.

```sql
SELECT
    funcionario.Pnome,
    funcionario.Unome
FROM
    funcionario
WHERE
	funcionario.Datanasc BETWEEN '1960-01-01' AND '1969-12-31'
```

## 2. Encontre o nome de todos os funcionários que nasceram entre '1960-01-01' AND '1969-12-31'. Uso obrigatório do BETWEEN.

```sql
SELECT
    funcionario.Pnome,
    funcionario.Unome
FROM
    funcionario
WHERE
	funcionario.Datanasc BETWEEN '1960-01-01' AND '1969-12-31'
```

## 3. Recuperar o nome e o sobrenome dos funcionários que não possuem dependentes. Uso obrigatório de IN ou NOT IN conforme necessidade.

```sql
SELECT
    funcionario.Pnome,
    funcionario.Unome
FROM
    funcionario
WHERE
	funcionario.Cpf NOT IN (SELECT dependente.Fcpf from dependente)
```

## 4. Recuperar a quantidade de funcionários por projeto, considerando apenas os funcionários que tenham horas de trabalho associado ao projeto. Isso significa que horas com valor em branco ou nulos não devem se contabilizados. Uso obrigatório de IS NULL ou IS NOT NULL conforme necessidade.

```sql
SELECT
    trabalha_em.Pnr,
    COUNT(trabalha_em.Fcpf)
FROM
    trabalha_em
WHERE
	trabalha_em.Horas IS NOT NULL
GROUP BY trabalha_em.Pnr
```

# Lista 3

## 8. Para cada projeto localizado em ‘Mauá’, liste o número do projeto, o número do departamento que o controla e o último nome, endereço e data de nascimento do gerente do departamento.

```sql
SELECT
    projeto.Projnumero,
    projeto.Dnum,
    funcionario.Unome,
    funcionario.Endereco,
    funcionario.Datanasc
FROM
    projeto
LEFT JOIN departamento ON departamento.Dnumero = projeto.Dnum
LEFT JOIN funcionario ON funcionario.Cpf = departamento.Cpf_gerente
WHERE
    projeto.Projlocal = "Mauá"
```

## 9. Descobrir os nomes dos funcionários que trabalham em todos os projetos controlados pelo departamento número 5.

> Conferir

```sql
SELECT
    funcionario.Pnome,
    funcionario.Unome
FROM
    funcionario
JOIN trabalha_em ON funcionario.Cpf = trabalha_em.Fcpf
JOIN projeto ON trabalha_em.Pnr = projeto.Projnumero AND projeto.Dnum = 5
GROUP BY
    funcionario.Cpf,
    funcionario.Pnome,
    funcionario.Unome
HAVING
    COUNT(DISTINCT trabalha_em.Pnr) =(
    SELECT
        COUNT(*)
    FROM
        projeto
    WHERE
        Dnum = 5
);
```

## 10. Fazer uma lista dos números de projeto para aqueles que envolvem um funcionário cujo último nome é ‘Silva’, seja como um trabalhador ou como um gerente do departamento que controla o projeto

```sql
SELECT
    projeto.Projnumero
FROM
    funcionario
LEFT JOIN projeto ON projeto.Dnum = funcionario.Dnr
WHERE
    funcionario.Unome = "Silva"
UNION SELECT
    projeto.Projnumero
FROM
    departamento
LEFT JOIN projeto ON projeto.Dnum = departamento.Dnumero
LEFT JOIN funcionario ON departamento.Cpf_gerente = funcionario.Cpf
WHERE
    funcionario.Unome = "Silva"
```

## 11. Listar os nomes dos funcionários com dois ou mais dependentes.

```sql
SELECT
    f.Pnome,
    f.Unome
FROM
    funcionario f
JOIN
    dependente d ON f.Cpf = d.Fcpf
GROUP BY
    f.Cpf, f.Pnome, f.Unome
HAVING
    COUNT(d.Fcpf) >= 2
```

## 12. Recuperar os nomes dos funcionários que não possuem dependentes.

```sql
SELECT
    funcionario.Pnome,
    funcionario.Unome
FROM
    funcionario
WHERE
    funcionario.Cpf NOT IN(
    SELECT
        dependente.Fcpf
    FROM
        dependente
)
```

## 13. Listar os nomes dos gerentes que têm pelo menos um dependente.

```sql
SELECT DISTINCT
    funcionario.Pnome,
    funcionario.Unome
FROM
    funcionario
INNER JOIN departamento ON departamento.Cpf_gerente = funcionario.Cpf
INNER JOIN dependente ON dependente.Fcpf = funcionario.Cpf
```

## 14. Recuperar os nomes de todos os funcionários do departamento número 5 que trabalham mais de 10 horas por semana no ‘ProdutoX’.

```sql
SELECT DISTINCT
    funcionario.Pnome,
    funcionario.Unome
FROM
    funcionario
INNER JOIN projeto ON projeto.Dnum = funcionario.Dnr
INNER JOIN trabalha_em ON trabalha_em.Fcpf = funcionario.Cpf AND trabalha_em.Pnr = projeto.Projnumero
WHERE
    funcionario.Dnr = 5 AND trabalha_em.Horas >= 10 AND projeto.Projnome = "ProdutoX"
```

## 15. Liste os nomes de todos os funcionários que tem um dependente com o primeiro nome igual ao seu.

```sql
SELECT DISTINCT
    funcionario.Pnome,
    funcionario.Unome
FROM
    funcionario
INNER JOIN dependente ON funcionario.Cpf = dependente.Fcpf
WHERE funcionario.Pnome = dependente.Nome_dependente
```

## 16. Para cada projeto, liste o nome do projeto e o total de horas por semana (por todos os funcionários) gastas nesse projeto.

```sql
SELECT
    projeto.Projnome,
    SUM(trabalha_em.Horas)
FROM
    projeto
INNER JOIN trabalha_em ON trabalha_em.Pnr = projeto.Projnumero
GROUP BY Projnome
```

## 17. Para cada departamento, recupere o nome do departamento e o salário médio de todos os seus funcionários.

```sql
SELECT
    departamento.Dnome,
    AVG(funcionario.Salario)
FROM
    departamento
LEFT JOIN funcionario ON departamento.Dnumero = funcionario.Dnr
GROUP BY Dnome
```

## 18. Recupere salário médiode todos os funcionários do sexo feminino.

```sql
SELECT
    funcionario.Sexo,
    AVG(funcionario.Salario)
FROM
    funcionario
WHERE
    funcionario.Sexo = "F"
GROUP BY
    Sexo
```

## 19. Liste o último nome de todos os gerentes de departamento que não possuem dependentes.

```sql
SELECT
    funcionario.Unome
FROM
    funcionario
INNER JOIN departamento ON funcionario.Cpf = departamento.Cpf_gerente
WHERE
    funcionario.Cpf NOT IN(
    SELECT
        dependente.Fcpf
    FROM
        dependente
)
```
