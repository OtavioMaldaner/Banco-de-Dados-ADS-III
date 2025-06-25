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
