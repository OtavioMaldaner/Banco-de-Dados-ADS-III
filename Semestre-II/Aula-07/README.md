# Lista 1

## Exercício 1 - Procedure simples

Crie uma procedure chamada aumenta_salario que receba dois parâmetros: id_func (INT) e percentual (DECIMAL). A procedure deve atualizar o salário do funcionário informado e retornar o novo salário.

```sql
DELIMITER
    $
CREATE PROCEDURE aumenta_salario(
    IN id_func INT,
    IN percentual DECIMAL(5, 2)
)
BEGIN
    UPDATE
        funcionarios
    SET
        funcionarios.salario =(
            funcionarios.salario * percentual
        )
    WHERE
        funcionarios.id = id_func ; END$
    DELIMITER
        ;
```

## Exercício 1B- Procedure simples com variável de saída

Crie uma procedure chamada aumenta_salario_v2 que receba dois parâmetros: id_func (INT) e percentual (DECIMAL). A procedure deve atualizar o salário do funcionário informado e retornar uma variável de saída com o texto “Salário atualizado para ” concatenado com o novo salário

```sql
DELIMITER
    $$
CREATE OR REPLACE PROCEDURE aumenta_salario_v2(
    IN id_func INT,
    IN percentual DECIMAL(5, 2),
    OUT saida DECIMAL(10, 2)
)
BEGIN
    DECLARE
        v_novo_salario DECIMAL(10, 2) ;
    SELECT
        salario *(1 +(percentual / 100))
    INTO v_novo_salario
FROM
    funcionarios
WHERE
    id = id_func ;
UPDATE
    funcionarios
SET
    salario = v_novo_salario
WHERE
    id = id_func ;
SET
    saida = v_novo_salario ; END $$
DELIMITER
    ;
```

## Exercício 2 - Procedure simples 2 (ajuste por setor + log)

Crie uma procedure chamada ajustar_salarios_setor que recebe id_setor e percentual, atualiza os salários de todos os funcionários do setor, registra o ajuste em log e retorna os novos salários.

```sql
DELIMITER
    $$
CREATE OR REPLACE PROCEDURE ajustar_salarios_setor(
    IN id_setor INT,
    IN percentual DECIMAL(5, 2)
)
BEGIN
    UPDATE
        funcionarios
    SET
        salario =(
            salario *(1 +(percentual / 100))
        )
    WHERE
        funcionarios.setor_id = id_setor ;
    INSERT INTO ajustes_salariais(
        ajustes_salariais.setor_id,
        ajustes_salariais.percentual_aplicado,
        ajustes_salariais.data_ajuste
    )
VALUES(
    id_setor,
    percentual,
    CURRENT_TIMESTAMP()) ;
SELECT
    *
FROM
    funcionarios ;
END $$
DELIMITER
    ;
```

## Exercício 3 - Procedure com laço WHILE

Crie uma procedure chamada inserir_numeros(qtd INT) que insere valores de 1 até qtd na tabela numeros usando um laço WHILE

```sql
DELIMITER
    $
CREATE PROCEDURE inserir_numeros(IN qtd INT)
BEGIN
    DECLARE
        I INT ;
    SET
        I = 1 ; calculo: WHILE(I <= qtd)
    DO
    INSERT INTO numeros(numeros.valor)
VALUES(I) ;
SET
    I = I + 1 ;
END WHILE calculo ; END$
DELIMITER
    ;
```
