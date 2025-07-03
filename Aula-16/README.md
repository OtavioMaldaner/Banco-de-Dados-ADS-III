# Lista 1

## 1) Quantos clientes (diferentes) compraram cada produto ?

```sql
SELECT
    produto.nome,
    COUNT(DISTINCT pedido.cliente_id) AS clientes_distintos
FROM
    produto
LEFT JOIN produto_pedido ON produto_pedido.produto_id = produto.id
LEFT JOIN pedido ON pedido.id = produto_pedido.id
GROUP BY
    produto.nome
```

## 2) Calcular o valor total vendido em cada categoria.

```sql
SELECT
    produto.categoria,
    SUM(
        produto.preco * produto_pedido.quantidade
    ) AS valor_vendido
FROM
    produto
LEFT JOIN produto_pedido ON produto_pedido.produto_id = produto.id
GROUP BY
    produto.categoria
```
