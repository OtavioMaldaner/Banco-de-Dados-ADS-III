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
