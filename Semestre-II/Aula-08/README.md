# Lista 1

## 1. Criar uma trigger para atualizar o estoque na tabela produtos toda vez que um produto for vendido (neste exercício vender significa inserir na tabela itensvenda).

```sql
DELIMITER $$

CREATE OR REPLACE TRIGGER atualizaEstoque
BEFORE INSERT ON itensvenda
FOR EACH ROW BEGIN
    UPDATE produtos
    SET estoque = estoque - NEW.quantidade
    WHERE produto_id = NEW.produto_id;
END$$

DELIMITER ;
```

## 2. Criar uma trigger para atualizar o estoque na tabela produtos toda vez que um for devolvido (neste exercício devolver significa apagar da tabela itensvenda).

```sql
DELIMITER $$

CREATE OR REPLACE TRIGGER devolverProduto
AFTER DELETE ON itensvenda
FOR EACH ROW BEGIN
    UPDATE produtos
    SET estoque = estoque + OLD.quantidade
    WHERE produto_id = OLD.produto_id;
END$$

DELIMITER ;
```

## 3. Criar uma trigger para atualizar o estoque na tabela produtos toda vez que a quantidade de um produto vendido for alterado (neste exercício significa alterar a quantidade na

tabela itensvenda).

```sql
DELIMITER $$

CREATE OR REPLACE TRIGGER alteraProduto
AFTER UPDATE ON itensvenda
FOR EACH ROW BEGIN
    UPDATE produtos
    SET estoque = estoque + OLD.quantidade - NEW.quantidade
    WHERE produto_id = OLD.produto_id;
END$$

DELIMITER ;
```

# Lista 2:

## 1 - Criar uma trigger para atualizar o estoque na tabela Flor toda vez que uma flor for vendida (um novo item for inserido na tabela ItensVenda).

```sql
DELIMITER $$

CREATE OR REPLACE TRIGGER venderFlor
AFTER INSERT ON itensvenda
FOR EACH ROW BEGIN
    UPDATE flor
    SET flor.estoque = estoque - NEW.quantidade
    WHERE flor.idFlor = NEW.idFlor;
END$$

DELIMITER ;
```

## 2- Criar uma trigger para inserir na tabela ComprasDevolvidas os dados referentes a uma devolução total de uma venda (uma linha da tabela ItensVenda for deletada).

```sql
DELIMITER $$

CREATE OR REPLACE TRIGGER devolverFlor
AFTER DELETE ON itensvenda
FOR EACH ROW BEGIN
    UPDATE flor
    SET flor.estoque = estoque + OLD.quantidade
    WHERE flor.idFlor = OLD.idFlor;
END$$

DELIMITER ;
```

## 3 - Criar uma trigger para apagar a linha da tabela de promoção de uma flor quando a mesma for inseridas na tabela ListaCompras.

```sql
DELIMITER $$

CREATE OR REPLACE TRIGGER removerPromocao
AFTER INSERT ON listacompras
FOR EACH ROW BEGIN
    DELETE FROM promocao
    WHERE promocao.idFlor = NEW.idFlor;
END$$

DELIMITER ;
```

## 4 - Criar uma trigger para inserir uma flor na tabela lista de compras toda vez que seu estoque for menor ou igual a quantidade mínima de estoque. A quantidade a ser comprada deve ser a diferença entre estoque máximo e o estoque atual.

```sql
DELIMITER
    $$
CREATE OR REPLACE TRIGGER criarListaCompras AFTER UPDATE
ON
    flor FOR EACH ROW
BEGIN
        IF NEW.estoque <= NEW.estoque_min THEN
        INSERT INTO `listacompras`(`idFlor`, `quantidade`)
    VALUES(
        NEW.idFlor,
        NEW.estoque_max - NEW.estoque
    ) ;
    END IF ; END $$
DELIMITER
    ;
```
