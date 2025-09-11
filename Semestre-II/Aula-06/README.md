# Lista 1

## Exercício 1: Soma dos Números: Crie uma função que aceita um número inteiro positivo N como parâmetro e retorna a soma dos números inteiros de 1 a N usando um laço WHILE.

```sql
DELIMITER
    $
CREATE FUNCTION soma_numeros(Valor INT) RETURNS INT BEGIN
    DECLARE
        I INT ;
    DECLARE Soma INT;
    SET
        Soma = 0 ;
    SET
        I = 1 ; WHILE I <= Valor
    DO
SET
    Soma = Soma + I ;
SET
    I = I + 1 ;
END WHILE ; RETURN Soma ; END
```

## Exercício 2: Tabuada: Crie uma função que aceita um número inteiro N como parâmetro e gera a tabuada desse número de 1 a 10 usando um laço REPEAT (o retorno da função deve ser um VARCHAR de tamanho suficiente para mostrar os resultados das multiplicações.

```sql
DELIMITER
    $
CREATE FUNCTION tabuada(n INT) RETURNS VARCHAR(1000) BEGIN
    DECLARE
        phrase VARCHAR(1000) DEFAULT "" ; DECLARE counter INT ;
    SET
        counter = 0 ; tabuada_repeat: REPEAT
    SET
        counter = counter + 1 ;
    SET
        phrase = CONCAT(
            phrase,
            n,
            " X ",
            counter,
            " = ",
            n * counter,
            "\n"
        ) ; UNTIL counter = 10
END REPEAT ; RETURN phrase ; END$
DELIMITER
    ;
```

## Exercício 3: Contagem Regressiva: Crie uma função que aceita um número inteiro positivo N como parâmetro e exibe uma contagem regressiva de N até 1 usando um laço LOOP.

```sql
DELIMITER
    $$
CREATE FUNCTION contagem_regressiva(n INT) RETURNS VARCHAR(1000) DETERMINISTIC BEGIN
    DECLARE
        resultado VARCHAR(1000) DEFAULT '' ; IF n <= 0 THEN RETURN 'Por favor, forneça um número inteiro positivo.' ;
END IF ; bucle_contagem: LOOP IF resultado = '' THEN
SET
    resultado = CAST(n AS CHAR) ; ELSE
SET
    resultado = CONCAT(resultado, ' ', n) ;
END IF ;
SET
    n = n - 1 ; IF n < 1 THEN LEAVE bucle_contagem ;
END IF ;
END LOOP bucle_contagem ; RETURN resultado ; END $$
DELIMITER
    ;
```
