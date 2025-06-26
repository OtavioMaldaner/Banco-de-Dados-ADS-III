# Lista 1

## 1) Selecione os clientes com seus pedidos (id e data do pedido). Clientes sem pedido também devem aparecer na lista.

```sql
SELECT *, pedido.id, pedido.data FROM cliente LEFT JOIN pedido ON pedido.cliente_id = cliente.id
```

## 2) Selecione os clientes com a sua quantidade de pedidos. Clientes sem pedido também devem aparecer na lista com a quantidade 0.

```sql
SELECT
    cliente.*,
    COUNT(pedido.id) AS num_pedidos
FROM
    cliente
LEFT JOIN pedido ON pedido.cliente_id = cliente.id
GROUP BY
    cliente_id
```

## 3) Selecione o nome dos produtos com o seu total de itens vendidos (coluna quantidade em produto_pedido). Produtos sem pedido também devem aparecer na lista.

```sql
SELECT
    produto.nome,
    SUM(produto_pedido.quantidade) AS itens_vendidos
FROM
    produto
LEFT JOIN produto_pedido ON produto_pedido.produto_id = produto.id
GROUP BY
    produto.nome
```

## 4) Mesmo enunciado anterior alterando: Produtos sem pedido devem aparecer na lista com a quantidade 0.

```sql
SELECT
    produto.nome,
    IFNULL(
        SUM(produto_pedido.quantidade),
        0
    ) AS itens_vendidos
FROM
    produto
LEFT JOIN produto_pedido ON produto_pedido.produto_id = produto.id
GROUP BY
    produto.nome
```

## 5) Selecionar o id e o nome de todos os produtos que tiveram ao menos algum pedido. Uso obrigatório do EXISTS.

```sql
SELECT
    produto.id,
    produto.nome
FROM
    produto
WHERE
    EXISTS(
    SELECT
        produto_pedido.produto_id
    FROM
        produto_pedido
    WHERE
        produto_pedido.produto_id = produto.id
)
```

## 6) Selecionar o nome e a quantidade em estoque de cada produto. Valores nulos devem ser substituídos por 0. Para testar ambas funções, retornar duas colunas com essa informação: uma utilizando IFNULL e outra utilizando o COALESCE.

```sql
SELECT
    produto.id,
    IFNULL(produto.quantidade, 0) AS qtd_estoque_IFNULL,
    COALESCE(produto.quantidade, 0) AS qtd_estoque_COALESCE
FROM
    produto
```

## 8) Retorne o nome do produto, sua quantidade, e um texto informando o seguinte:

> 'Estoque adequado' quando o produto tiver mais de 10 itens em estoque.
>
> 'Estoque regular' quando o produto tiver entre 5 e 10 itens em estoque.
>
> 'Estoque baixo' quando o produto tiver entre 1 e 4 itens em estoque.
>
> 'Indisponível' quando o produto tiver mais de 0 itens em estoque.

```sql
SELECT
    produto.id,
    IFNULL(produto.quantidade, 0) AS qtd_estoque_IFNULL,
    CASE
    	WHEN produto.quantidade > 10
        THEN "Estoque adequado"
        WHEN produto.quantidade <= 10 AND produto.quantidade >= 5
        THEN "Estoque regular"
        WHEN produto.quantidade <= 4 AND produto.quantidade > 1
        THEN "Estoque baixo"
        ELSE "Indisponível"
    END AS status_estoque
FROM
    produto
```

# Lista 2 - Subconsultas

## 1. Liste os nomes dos funcionários que recebem salário maior que o salário do funcionário chamado 'João'.

```sql
SELECT
    funcionario.Pnome
FROM
    funcionario
WHERE
    funcionario.Salario >(
    SELECT
        funcionario.Salario
    FROM
        funcionario
    WHERE
        funcionario.Pnome LIKE "%João%"
)
```

## 2. Mostre o nome e salário dos funcionários cujo salário seja maior que a média salarial do departamento 'Administração'.

```sql
SELECT
    funcionario.Pnome,
    funcionario.Salario
FROM
    funcionario
WHERE
    funcionario.Salario >(
    SELECT
        AVG(funcionario.Salario)
    FROM
        funcionario
    JOIN departamento ON departamento.Dnumero = funcionario.Dnr
    WHERE
        departamento.Dnome LIKE "%Administração%"
)
```

## 3. Exiba o nome dos departamentos cujo número de funcionários é igual ao número de projetos que ele gerencia.

```sql
SELECT
    departamento.Dnome
FROM
    departamento
WHERE
    (
    SELECT
        COUNT(*)
    FROM
        funcionario
    WHERE
        funcionario.Dnr = departamento.Dnumero
) =(
    SELECT
        COUNT(*)
    FROM
        projeto
    WHERE
        projeto.Dnum = departamento.Dnumero
);
```

## 4. Exibir os nomes dos projetos nos quais não há nenhum funcionário que tenha o mesmo sobrenome que o gerente do departamento do projeto.

```sql
SELECT
    projeto.Projnome
FROM
    projeto
WHERE NOT
    EXISTS(
    SELECT
        1
    FROM
        trabalha_em
    JOIN funcionario ON trabalha_em.Fcpf = funcionario.Cpf
    JOIN departamento ON projeto.Dnum = departamento.Dnumero
    JOIN funcionario gerente ON
        departamento.Cpf_gerente = gerente.Cpf
    WHERE
        trabalha_em.Pnr = projeto.Projnumero AND funcionario.Unome = gerente.Unome
);
```

## 5. Mostre os nomes dos funcionários que trabalham nos mesmos projetos que o funcionário chamado 'Alice', mas que não sejam a própria Alice.

```sql
SELECT DISTINCT
    funcionario.Pnome
FROM
    funcionario
JOIN trabalha_em ON trabalha_em.Fcpf = funcionario.Cpf
WHERE
    trabalha_em.Pnr IN(
    SELECT
        trabalha_em.Pnr
    FROM
        funcionario
    JOIN trabalha_em ON trabalha_em.Fcpf = funcionario.Cpf
    WHERE
        funcionario.Pnome LIKE "%Alice%"
) AND funcionario.Pnome <> "Alice"
```

## 6. Liste o nome dos funcionários que trabalham nos mesmos projetos e com a mesma carga horária que outro funcionário chamado 'Fernando'.

```sql
SELECT
    funcionario.Pnome
FROM
    funcionario
JOIN trabalha_em ON trabalha_em.Fcpf = funcionario.Cpf
WHERE
    trabalha_em.Pnr IN(
    SELECT
        trabalha_em.Pnr
    FROM
        funcionario
    JOIN trabalha_em ON trabalha_em.Fcpf = funcionario.Cpf
    WHERE
        funcionario.Pnome LIKE "%Fernando%"
) AND trabalha_em.Horas =(
    SELECT
        SUM(trabalha_em.Horas)
    FROM
        trabalha_em
    JOIN funcionario ON trabalha_em.Fcpf = funcionario.Cpf
    WHERE
        funcionario.Pnome LIKE "%Fernando%"
    GROUP BY
        funcionario.Pnome
)
```

## 7. Para cada departamento, exiba: Nome do departamento, Total de funcionários e Média salarial. Use uma subconsulta no FROM para calcular a média salarial por departamento.

```sql
SELECT
    departamento.Dnome AS "Nome do Departamento",
    COUNT(funcionario.Cpf) AS "Total de Funcionários",
    ROUND(avg_salarios.media_salarial, 2) AS "Média Salarial"
FROM
    departamento
JOIN funcionario ON departamento.Dnumero = funcionario.Dnr
JOIN(
    SELECT Dnr,
        AVG(Salario) AS media_salarial
    FROM
        funcionario
    GROUP BY
        Dnr
) avg_salarios
ON
    funcionario.Dnr = avg_salarios.Dnr
GROUP BY
    departamento.Dnome,
    avg_salarios.media_salarial
ORDER BY
    departamento.Dnome;
```

## 8. Liste os nomes dos funcionários cujo salário é acima da média salarial de seu departamento, e que não possuem dependentes.

```sql
WITH
    media_salarial_depto AS(
    SELECT
        funcionario.Dnr,
        AVG(funcionario.Salario) AS media_salarial
    FROM
        funcionario
    GROUP BY
        funcionario.Dnr
)
SELECT
    funcionario.Pnome
FROM
    funcionario
JOIN media_salarial_depto ON funcionario.Dnr = media_salarial_depto.Dnr
WHERE
    funcionario.Salario >= media_salarial_depto.media_salarial AND funcionario.Cpf NOT IN(
    SELECT DISTINCT
        dependente.Fcpf
    FROM
        dependente
)
```

## 9. Para cada departamento, exiba: Nome do departamento e quantidade de funcionários que possuem salário maior que a média salarial dos funcionários com dependentes.

```sql
WITH
    media_salarial_depto AS(
    SELECT
        funcionario.Dnr,
        AVG(funcionario.Salario) AS media_salarial
    FROM
        funcionario
    GROUP BY
        funcionario.Dnr
)
SELECT
    departamento.Dnome,
    COUNT(funcionario.Cpf) AS cont_funcionarios
FROM
    funcionario
JOIN departamento ON departamento.Dnumero = funcionario.Dnr
JOIN media_salarial_depto ON funcionario.Dnr = media_salarial_depto.Dnr
WHERE
    funcionario.Salario >= media_salarial_depto.media_salarial
GROUP BY departamento.Dnome
```
