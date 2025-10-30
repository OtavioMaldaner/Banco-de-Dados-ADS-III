# Lista 01

## Considere uma tabela de pedidos de clientes em que seja necessário limitar que um cliente faça no máximo 5 pedidos por dia. Crie um trigger que, antes de inserir um novo pedido na tabela pedidos, verifique se o cliente já fez o máximo de 5 pedidos no mesmo dia e, se sim, recuse a operação.

```sql
-- Tabela clientes
CREATE TABLE clientes (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40),
 cidade VARCHAR(40)
);
-- Tabela pedidos
CREATE TABLE pedidos (
 id INT AUTO_INCREMENT PRIMARY KEY,
 cliente_id INT,
 data_pedido DATE,
 valor_total DECIMAL(10, 2),
 FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
```

```sql
DELIMITER
    $$
CREATE OR REPLACE TRIGGER adicionarPedido BEFORE INSERT ON
    pedidos FOR EACH ROW
BEGIN
    DECLARE
        contagem INT ;
    SELECT
        COUNT(*)
    INTO contagem
FROM
    pedidos
WHERE
    pedidos.cliente_id = NEW.cliente_id AND pedidos.data_pedido = NEW.data_pedido ; IF contagem >= 5 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT
    = 'O cliente já atingiu o número máximo de pedidos para esse dia!',
    MYSQL_ERRNO = 1001 ;
END IF ; END $$
```

## Atividade 2 - PDF Anexado

```sql
DELIMITER
    $$
CREATE OR REPLACE TRIGGER adicionarInscricao BEFORE INSERT ON
    inscricoes FOR EACH ROW
BEGIN
    DECLARE
        contagem_inscricoes_atividade INT ; DECLARE limite_diario INT ; DECLARE limite_participantes_diario INT ; DECLARE limite_vagas_atividade INT ; DECLARE inscricoes_diarias INT ; DECLARE categoria_participante INT ; DECLARE inscricoes_diarias_categorias INT ;
    SELECT
        participantes.categoria_id
    INTO categoria_participante
FROM
    participantes
WHERE
    participantes.id = NEW.participante_id ;
SELECT
    categorias.limite_diario
INTO limite_diario
FROM
    categorias
JOIN participantes ON participantes.categoria_id = categorias.id
WHERE
    participantes.id = NEW.participante_id ;
SELECT
    categorias.limite_participantes_diario
INTO limite_participantes_diario
FROM
    categorias
JOIN participantes ON participantes.categoria_id = categorias.id
WHERE
    participantes.id = NEW.participante_id ;
SELECT
    limite_vagas
INTO limite_vagas_atividade
FROM
    `atividades`
WHERE
    atividades.id = NEW.atividade_id ;
SELECT
    COUNT(*)
INTO contagem_inscricoes_atividade
FROM
    `inscricoes`
WHERE
    inscricoes.atividade_id = NEW.atividade_id ;
SELECT
    COUNT(*)
INTO inscricoes_diarias
FROM
    `inscricoes`
WHERE
    participante_id = NEW.participante_id AND data_inscricao = NEW.data_inscricao ;
SELECT
    COUNT(*)
INTO inscricoes_diarias_categorias
FROM
    `inscricoes`
JOIN participantes ON participante_id = participantes.id
WHERE
    participantes.categoria_id = categoria_participante AND data_inscricao = NEW.data_inscricao ;

     IF inscricoes_diarias >= limite_diario THEN
    SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'O aluno já atingiu o número máximo de inscrições para esse dia!',
    	MYSQL_ERRNO = 1001 ;
    ELSEIF contagem_inscricoes_atividade >= limite_vagas_atividade THEN
    SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'O limite de inscições para essa atividade já foi atingido!',
    MYSQL_ERRNO = 1001 ;
    ELSEIF inscricoes_diarias_categorias >= limite_participantes_diario THEN
    SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'O número de inscrições da categoria desse aluno já atingiu o número máximo para esse dia!',
    	MYSQL_ERRNO = 1001 ;
END IF ;
END $$
```
