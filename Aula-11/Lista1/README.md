# Lista 1
## 1. Recupere o nome dos clientes e o valor total das suas compras.
```sql
SELECT
    cliente.nome_cliente,
    SUM(
        item.preco_unitario * item_pedido.quantidade
    ) AS preco
FROM
    `cliente`
LEFT JOIN pedido ON pedido.num_cliente = cliente.num_cliente
LEFT JOIN item_pedido ON pedido.num_pedido = item_pedido.num_pedido
LEFT JOIN item ON item.num_item = item_pedido.num_item
GROUP BY
    cliente.nome_cliente
```

## 2. Recuperar o nome dos clientes, a quantidade de pedidos realizados, e a quantidade total de itens comprados.
```sql
SELECT
    cliente.nome_cliente,
    COUNT(DISTINCT pedido.num_pedido) AS pedidos,
    SUM(item_pedido.quantidade) AS total_itens
FROM
    `cliente`
LEFT JOIN pedido ON pedido.num_cliente = cliente.num_cliente
LEFT JOIN item_pedido ON pedido.num_pedido = item_pedido.num_pedido
GROUP BY
    cliente.nome_cliente
```

## 3. Recuperar a quantidade de pedidos realizados por cidade.
```sql
SELECT
    cliente.cidade,
    COUNT(pedido.num_pedido) AS pedidos
FROM
    `cliente`
LEFT JOIN pedido ON pedido.num_cliente = cliente.num_cliente
GROUP BY
    cliente.cidade
```

## 4. Recupere a quantidade de itens vendidos para cada item da tabela ITEM.
```sql
SELECT
    item.descricao,
    SUM(item_pedido.quantidade) AS total_itens
FROM
    `item`
LEFT JOIN item_pedido ON item.num_item = item_pedido.num_item
LEFT JOIN pedido ON pedido.num_pedido = item_pedido.num_pedido
GROUP BY
    item.descricao
```

## 5. Listar a cidade de todos clientes que tenham comprado o item ‘Frigobar’ mas não tenham comprado o item ‘DVD’.
```sql
SELECT DISTINCT c.cidade
FROM cliente c
JOIN pedido p ON c.num_cliente = p.num_cliente
JOIN item_pedido ip ON p.num_pedido = ip.num_pedido
JOIN item i ON ip.num_item = i.num_item
WHERE i.descricao = 'Frigobar'
AND c.num_cliente NOT IN (
    SELECT c2.num_cliente
    FROM cliente c2
    JOIN pedido p2 ON c2.num_cliente = p2.num_cliente
    JOIN item_pedido ip2 ON p2.num_pedido = ip2.num_pedido
    JOIN item i2 ON ip2.num_item = i2.num_item
    WHERE i2.descricao = 'DVD'
);
```

## 6. Selecionar o nome dos clientes da cidade “Caxias” que compraram “DVD” e também o nome dos clientes da cidade “Garibaldi” que compraram “Frigobar”.
```sql
SELECT
    cliente.nome_cliente
FROM
    `cliente`
LEFT JOIN pedido ON pedido.num_cliente = cliente.num_cliente
LEFT JOIN item_pedido ON pedido.num_pedido = item_pedido.num_pedido
LEFT JOIN item ON item_pedido.num_item = item.num_item
WHERE
    cliente.cidade = "Caxias" AND item.descricao = "DVD"
GROUP BY
    cliente.nome_cliente
UNION
SELECT
    cliente.nome_cliente
FROM
    `cliente`
LEFT JOIN pedido ON pedido.num_cliente = cliente.num_cliente
LEFT JOIN item_pedido ON pedido.num_pedido = item_pedido.num_pedido
LEFT JOIN item ON item_pedido.num_item = item.num_item
WHERE
    cliente.cidade = "Garibaldi" AND item.descricao = "Frigobar"
GROUP BY
    cliente.nome_cliente
```
## 7. Uma empresa quer fazer uma oferta especial de ‘Playstation 4’ para todos os clientes que tenham comprado o item ‘TV LED 60’ mas não tenham comprado o item ‘Playstation 4’. A empresa precisa apenas do nome dos clientes. Gere essa lista usando SQL.
```sql
SELECT
    cliente.nome_cliente
FROM
    `cliente`
LEFT JOIN pedido ON pedido.num_cliente = cliente.num_cliente
LEFT JOIN item_pedido ON pedido.num_pedido = item_pedido.num_pedido
LEFT JOIN item ON item_pedido.num_item = item.num_item
WHERE
    item.descricao = "TV LED 60" AND pedido.num_pedido NOT IN(
    SELECT
        item_pedido.num_pedido
    FROM
        item_pedido
    LEFT JOIN item ON item.num_item = item_pedido.num_item
    WHERE
        item.descricao = "Playstation 4"
)
GROUP BY
    cliente.nome_cliente
```