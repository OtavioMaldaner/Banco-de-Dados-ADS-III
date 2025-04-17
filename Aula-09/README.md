# Lista de Exercícios

## 1. Recuperar o número do pedido, a data do pedido e o nome do cliente de cada pedido.

```sql
SELECT numPedido, dataPedido,cliente.nomeCliente FROM pedido LEFT JOIN cliente ON pedido.numCliente = cliente.numCliente
```

## 2. Recuperar o número do pedido, a descrição dos itens e a quantidade de itens de cada pedido.

```sql
SELECT item_pedido.numPedido, descricao, item_pedido.quantidade FROM pedido LEFT JOIN item_pedido ON pedido.numPedido = item_pedido.numPedido LEFT JOIN item ON item_pedido.numItem = item.numItem;
```

## 3. Recuperar o nome dos clientes que compraram o item “TV LED 32”.

```sql
SELECT cliente.nomeCliente
FROM cliente
INNER JOIN pedido ON pedido.numCliente = cliente.numCliente
INNER JOIN item_pedido ON item_pedido.numPedido = pedido.numPedido
INNER JOIN item ON item.numItem = item_pedido.numItem WHERE descricao = "TV LED 32";
```

# Lista Exercícos 2

## 1. Recuperar o nome, a data de nascimento e o nome do departamento dos funcionários. Ordenar o resultado pelo nome do departamento seguido da data de nascimento.

```sql
SELECT funcionario.Pnome, funcionario.Datanasc, departamento.Dnome FROM funcionario LEFT JOIN departamento ON departamento.Dnumero = funcionario.Dnr ORDER BY Dnome, Datanasc;
```

## 2. Listar os nomes dos departamentos que possuem funcionários do sexo masculino. Os nomes dos departamentos não podem aparecer repetidos no resultado.

```sql
SELECT DISTINCT departamento.Dnome FROM departamento LEFT JOIN funcionario ON departamento.Dnumero = funcionario.Dnr WHERE funcionario.Sexo = "M";
```

## 3. Listar os nomes dos funcionários que tenham a letra “a” no nome e que o sobrenome termine com a letra “o”

```sql
SELECT funcionario.Pnome, funcionario.Unome FROM funcionario WHERE Pnome LIKE "%a%" AND Unome LIKE "%o";
```

## 4. Listar os nomes dos funcionários, seu salário e o possível salário se fosse dado um aumento de 25%.

```sql
SELECT funcionario.Pnome, funcionario.Salario, funcionario.Salario * 1.25 as possivel_aumento FROM funcionario;
```
