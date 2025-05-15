# Lista 1
## 1. Faça uma consulta que retorne o nome de cada funcionário e qual foi o dia da semana (segunda, terça, ...) do primeiro aniversário do funcionário.
```sql
SELECT
    funcionario.Pnome,
    DATE_FORMAT(
        DATE_ADD(
            funcionario.Datanasc,
            INTERVAL 1 YEAR
        ),
        "%W"
    ) AS dia_primeiro_aniversario
FROM
    `funcionario`
WHERE
    1
```

## 2. Faça uma consulta que retorne o nome do funcionário em letras maiúsculas, seu departamento e o número de dias que o funcionário trabalhou em Agosto (mês 08) de acordo com as informações que estão no ponto dos funcionários (tabela folha_ponto). A consulta deve restringir para retornar somente funcionários que tenham trabalhado menos de 20 dias no mês de acordo com o que consta na tabela folha_ponto. 
```sql
SELECT
    UPPER(funcionario.Pnome),
    departamento.Dnome,
    COUNT(folha_ponto.entrada) AS dias_trabalhados
FROM
    `funcionario`
LEFT JOIN departamento ON departamento.Dnumero = funcionario.Dnr
LEFT JOIN folha_ponto ON folha_ponto.cpf = funcionario.Cpf
WHERE
    MONTH(folha_ponto.entrada) = 8
GROUP BY
    funcionario.Pnome
```

## 3. Faça uma consulta que atenda a seguinte situação: quando o nome e o sobrenome do funcionário concatenados (ex.: 'Fernando Wong Xu') tiverem mais de 12 caracteres, retornar o nome do funcionário concatenado com o sobrenome, porém, abreviando o sobrenome colocando apenas a primeira letra seguida de um ponto (.) (exe. "Fernando W."). Para os demais nomes retornar nome e sobrenome concatenados completos.
```sql
SELECT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_completo,
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        CONCAT(LEFT(funcionario.Unome, 1),
        ".")
    ) AS nome_formatado
FROM
    `funcionario`
WHERE
    CHAR_LENGTH(
        CONCAT_WS(
            " ",
            funcionario.Pnome,
            funcionario.Unome
        )
    ) > 12
UNION
SELECT
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_completo,
    CONCAT_WS(
        " ",
        funcionario.Pnome,
        funcionario.Unome
    ) AS nome_formatado
FROM
    funcionario
WHERE
    CHAR_LENGTH(
        CONCAT_WS(
            " ",
            funcionario.Pnome,
            funcionario.Unome
        )
    ) <= 12
```

## 4. Faça uma consulta que retorne os dias que o funcionário fez hora extra, ou seja, os dias em que o funcionário trabalhou mais de 8h (considerar que existe 1 hora de intervalo para almoço no tempo marcado no ponto). Retornar na consulta o nome do funcionário, o dia do ponto, a hora de entrada, a hora de saída, o total de horas contabilizadas no dia, uma coluna para representar as horas extras e outra para os minutos extras.

```sql
SELECT
    funcionario.Pnome,
    DAYOFMONTH(folha_ponto.entrada) AS dia,
    TIME(folha_ponto.entrada) AS entrada,
    TIME(folha_ponto.saida) AS saida,
    TIMEDIFF(
        TIME(folha_ponto.saida),
        TIME(folha_ponto.entrada)
    ) AS totalHorasPonto,
    HOUR(
        TIMEDIFF(
            TIMEDIFF(
                TIME(folha_ponto.saida),
                TIME(folha_ponto.entrada)
            ),
            "09:00:00"
        )
    ) AS horasExtras,
    MINUTE(
        TIMEDIFF(
            TIMEDIFF(
                TIME(folha_ponto.saida),
                TIME(folha_ponto.entrada)
            ),
            "09:00:00"
        )
    ) AS minutosExtras
FROM
    funcionario
LEFT JOIN folha_ponto ON funcionario.Cpf = folha_ponto.cpf
WHERE
    TIMEDIFF(
        TIME(folha_ponto.saida),
        TIME(folha_ponto.entrada)
    ) > "09:00:00"
```