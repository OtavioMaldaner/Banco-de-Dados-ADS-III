# Exercícios

## Inserção dos dados
```sql
INSERT INTO `cliente`(`nome_cliente`, `cidade`) VALUES ('Tulio','Feliz'), ('João','Feliz'), ('Pedro','Caxias');
```

```sql
INSERT INTO `item`(`num_item`, `descricao`, `preco_unitario`) VALUES (123,'TV LED 32',900.00), (124,'DVD',100.00), (125,'Playstation 4',1800.00),(126,'Frigobar',300.00);
```

```sql
INSERT INTO `pedido`(`data_pedido`, `num_cliente`) VALUES ('2013-06-08',3), ('2013-06-09',3), ('2013-06-05',1);
```

```sql
INSERT INTO `item_pedido`(`num_pedido`, `num_item`, `quantidade`) VALUES (1,123,1), (1,124,1), (2,126,5), (3,123,2), (3,125,2);
```

## Crie uma consulta para recuperar o nome dos clientes da cidade de Feliz.

```sql
SELECT * FROM cliente WHERE cliente.cidade = "Feliz";
```

## Crie uma consulta para recuperar a descrição dos itens com preço superior a 500.00.
```sql
SELECT * FROM item WHERE item.preco_unitario > 500;
```

## Crie um comando para alterar o preço do item “Playstation 4” para 1500.00.
```sql
UPDATE `item` SET `preco_unitario`= 1500.00 WHERE item.descricao = "Playstation 4";
```

## Crie um comando para apagar o item de número 125.
```sql
DELETE FROM item_pedido WHERE num_item = 125;
DELETE FROM item WHERE num_item = 125
```