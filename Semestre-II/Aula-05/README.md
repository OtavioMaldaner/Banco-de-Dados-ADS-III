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

# Lista 2

## 1. Crie a função TotalHoras para retornar o total de horas que um funcionário trabalha. O parâmetro de entrada da função deve ser o cpf do funcionário. A função deve retornar o total de horas que o funcionário trabalha (tabela trabalha_em).

```sql
CREATE OR REPLACE FUNCTION TotalHoras(cpf_funcionario BIGINT)
RETURNS DECIMAL
RETURN(
    SELECT
        SUM(trabalha_em.Horas)
    FROM
        trabalha_em
    WHERE
        trabalha_em.Fcpf = cpf_funcionario
);
```

## 2. Crie a função TotalHorasProjetos para retornar o total de horas e o número de projetos que um funcionário trabalha. O parâmetro de entrada da função deve ser o cpf do funcionário. A função deve retornar de forma concatenada o total de horas que o funcionário trabalha e a quantidade de projetos que o funcionário trabalha. Exemplo de retorno da função: '10h - 2 projetos'.

```sql
CREATE OR REPLACE FUNCTION TotalHorasProjetos(cpf_funcionario BIGINT)
RETURNS VARCHAR(55)
RETURN(
    SELECT
        CONCAT_WS(
            " - ",
            CONCAT(SUM(trabalha_em.Horas), "h"),
            CONCAT_WS(" ", COUNT(trabalha_em.Pnr), "projetos")
        )
    FROM
        trabalha_em
    WHERE
        trabalha_em.Fcpf = cpf_funcionario
);
```

## 3. Crie a função TotalFuncionários para retornar a quantidade de funcionários que trabalham em um determinado projeto. O parâmetro de entrada da função deve ser o nome do projeto. A função deve retornar a quantidade de funcionários que trabalha no projeto indicado.

```sql
CREATE OR REPLACE FUNCTION TotalFuncionarios(nome_projeto VARCHAR(20))
RETURNS INT
RETURN(
    SELECT
        COUNT(trabalha_em.Pnr)
    FROM
        trabalha_em
    JOIN
    	projeto ON projeto.Projnumero = trabalha_em.Pnr
    WHERE
        projeto.Projnome = nome_projeto
);
```

## 4. Crie a função MediaSalDep para retornar a média salarial dos funcionários de um departamento. O parâmetro de entrada da função deve ser o nome do departamento. A função deve retornar a média salarial dos funcionários que trabalham no departamento indicado.

```sql
CREATE OR REPLACE FUNCTION MediaSalDep(nome_departamento VARCHAR(25))
RETURNS DECIMAL
RETURN(
    SELECT
        AVG(funcionario.Salario)
    FROM
        funcionario
    JOIN
    	departamento ON departamento.Dnumero = funcionario.Dnr
    WHERE
        departamento.Dnome = nome_departamento
);
```

# Lista 3

## 1-Criar uma função que recebe o CPF do funcionário e retorna o valor do aumento do funcionário. Se a soma de horas trabalhadas em projetos pelo funcionário for maior ou igual a 40, o aumento deve ser de 20%. Caso contrário o aumento deve ser de 5%.

```sql
DELIMITER
    $
CREATE OR REPLACE FUNCTION valorAumento(cpf BIGINT) RETURNS DOUBLE BEGIN
    DECLARE
        horas DECIMAL ; DECLARE aumento DOUBLE ;
    SET
        horas =(
        SELECT
            SUM(trabalha_em.Horas)
        FROM
            trabalha_em
        WHERE
            trabalha_em.Fcpf = cpf
    ) ; IF horas >= 40 THEN
SET
    aumento = 1.2 ; ELSE
SET
    aumento = 1.05 ;
END IF ; RETURN aumento ; END$
DELIMITER
    ;
```

## 2-Fazer uma consulta para mostrar o uso da função que retorne o nome do funcionário e seu novo salário.

```sql
SELECT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome,
    funcionario.Salario AS salario_atual,
    valorAumento(funcionario.Cpf) * funcionario.Salario AS novo_salario
FROM
    funcionario;
```

## 3-Criar uma função que recebe três 3 números de projeto como parâmetro e retorna o projeto com mais funcionários trabalhando nele.

```sql
DELIMITER $

CREATE OR REPLACE FUNCTION projeto_mais_funcionarios(projeto1 INT, projeto2 INT, projeto3 INT)
RETURNS INT
BEGIN
    DECLARE projeto_maior INT;
    DECLARE count1 INT;
    DECLARE count2 INT;
    DECLARE count3 INT;


    SELECT COUNT(DISTINCT trabalha_em.Fcpf) INTO count1
    FROM trabalha_em
    WHERE Pnr = projeto1;


    SELECT COUNT(DISTINCT trabalha_em.Fcpf) INTO count2
    FROM trabalha_em
    WHERE Pnr = projeto2;


    SELECT COUNT(DISTINCT trabalha_em.Fcpf) INTO count3
    FROM trabalha_em
    WHERE Pnr = projeto3;


    IF count1 >= count2 AND count1 >= count3 THEN
        SET projeto_maior = projeto1;
    ELSEIF count2 >= count1 AND count2 >= count3 THEN
        SET projeto_maior = projeto2;
    ELSE
        SET projeto_maior = projeto3;
    END IF;

    RETURN projeto_maior;
END $

DELIMITER ;
```

## 4-Fazer uma consulta para mostrar o uso da função.

```sql
SELECT projeto_mais_funcionarios(1, 2, 3) AS projeto_maior;
```
