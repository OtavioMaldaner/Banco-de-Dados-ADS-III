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
