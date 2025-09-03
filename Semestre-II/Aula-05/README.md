# Lista Atividades

## 1-Criar uma função que recebe a data de nascimento do funcionário e retorna a idade do funcionário. Dica: procurar funções de data(date) do MySQL pode ajudar.

```sql
CREATE OR REPLACE FUNCTION calcular_idade (data_nasc DATE)
RETURNS INT
RETURN YEAR(FROM_DAYS(DATEDIFF(CURRENT_DATE, data_nasc)))
```

## 2-Fazer um select que retorne o nome e a idade de todos os funcionário demostrando o uso da função.

```sql
SELECT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome,
    calcular_idade(funcionario.Datanasc) AS idade
FROM
    funcionario
```

## 3-Criar uma função que recebe o CPF do funcionário e retorna o número de dependentes do funcionário

```sql
CREATE OR REPLACE FUNCTION dependentes_funcionario (cpf_funcionario BIGINT)
RETURNS INT
RETURN(
    SELECT COUNT(dependente.Fcpf)
    FROM dependente
    WHERE dependente.Fcpf = cpf_funcionario
);
```

## 4-Fazer um select que retorne o nome e o número de dependentes de um funcionário informado na função.

```sql
SELECT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome,
    dependentes_funcionario(funcionario.Cpf) AS dependentes
FROM
    funcionario
WHERE
    funcionario.Cpf = 12345678966
```

## 5-Fazer um select que retorne o nome e o número de dependentes de todos os funcionários.

```sql
SELECT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome,
    dependentes_funcionario(funcionario.Cpf) AS dependentes
FROM
    funcionario
```
