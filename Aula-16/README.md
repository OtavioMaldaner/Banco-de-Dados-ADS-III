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
    SUM(
        CASE WHEN produto.categoria = 'A' THEN produto.preco * produto_pedido.quantidade ELSE 0
    END
) AS "A",
SUM(
    CASE WHEN produto.categoria = 'B' THEN produto.preco * produto_pedido.quantidade ELSE 0
END
) AS "B",
SUM(
    CASE WHEN produto.categoria = 'C' THEN produto.preco * produto_pedido.quantidade ELSE 0
END
) AS "C",
SUM(
    CASE WHEN produto.categoria = 'D' THEN produto.preco * produto_pedido.quantidade ELSE 0
END
) AS "D"
FROM
    produto
LEFT JOIN produto_pedido
ON
    produto_pedido.produto_id = produto.id;
```
