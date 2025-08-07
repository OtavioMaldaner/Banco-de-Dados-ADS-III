# Exercício 2

Você é o responsável pelo banco de dados de uma empresa e percebeu que a tabela funcionarios possui os nomes dos departamentos diretamente inseridos nela. Você identifica que seria interessante ter uma tabela para armazenar as informações dos departamentos e na tabela funcionarios apenas fazer referência a essa nova tabela. Crie um script para fazer todas as alterações necessárias. O script deve estar em um único arquivo que será importado para realizar todas as alterações.

```sql
CREATE TABLE departamento AS
SELECT DISTINCT
    departamento AS nome_departamento,
    gerente_departamento
FROM
    funcionario
WHERE
    departamento IS NOT NULL;

ALTER TABLE departamento
ADD COLUMN numero_departamento INT PRIMARY KEY AUTO_INCREMENT FIRST;

ALTER TABLE departamento
ADD CONSTRAINT fk_gerente
FOREIGN KEY (gerente_departamento) REFERENCES funcionario(Cpf);

ALTER TABLE departamento
ADD UNIQUE (nome_departamento);

ALTER TABLE funcionario
ADD COLUMN numero_departamento INT;

UPDATE funcionario f
JOIN departamento d ON f.departamento = d.nome_departamento
SET f.numero_departamento = d.numero_departamento;

ALTER TABLE funcionario
ADD CONSTRAINT fk_funcionario_departamento
FOREIGN KEY (numero_departamento) REFERENCES departamento(numero_departamento);

ALTER TABLE funcionario DROP departamento;
```

# Exercício 3

Você é o responsável pelo banco de dados de uma empresa e recebeu uma tabela antiga populada com alguns dados de exemplo. Porém, no sistema atual da empresa as tabelas foram projetadas considerando o processo de normalização. Como responsável, você precisa definir um conjunto de comandos SQL para inserir os dados da tabela recebida nas tabelas do sistema atual garantindo a integridade dos dados. Considere que:

- a. Considere que você recebeu nesta atividade a tabela antiga com apenas parte dos dados. Quando seus comandos SQL forem executados na tabela com todos os dados, os comandos devem funcionar corretamente. Tabela antiga: nota_antiga.

- b. Você recebeu uma cópia sem dados da estrutura das tabelas atuais do sistema. Porém, seus comandos SQLs devem considerar que já existam dados nas tabelas e que estes não podem ser duplicados nem perdidos. Note que em algumas tabelas do sistema atual os atributos chaves são AUTO_INCREMENT. Tabelas atuais do sistema: cliente, item_nota, nota, produto, vendedor.

- c. Adicionalmente, você deve adicionar na tabela item_nota uma coluna calculada (armazenada) para o cálculo do total do item vendido naquele registro (preco \* quantidade). Nomear a coluna de total.
- d. Por fim, na tabela antiga a coluna vl_total_nota está com o valor igual a 0 (zero) para todas as compras. Você deve, já no banco atual do sistema (após a inserção dos dados), criar um comando SQL para atualizar o valor da coluna valorTotal conforme as vendas realizadas em cada nota.

**Tabela recebida**
nota_antiga: nr_nota, nome_cliente, cpf_cliente, ds_endereco_cliente, nome_vendedor, data_emissao, cd_prod1, ds_prod1, unidade1, quantidade1, preco1, vl_total1, cd_prod2, ds_prod2, unidade2, quantidade2, preco2, vl_total2, cd_prod3, ds_prod3, unidade3, quantidade3, preco3, vl_total3, cd_prod4, ds_prod4, unidade4, quantidade4, preco4, vl_total4, vl_total_nota

**Entregas da questão:**
 Lista de comandos SQL em ordem correta de execução considerando os dados que devem ser
incluídos antes dos outros.

```sql
INSERT INTO vendedor(nome)
SELECT DISTINCT nota_antiga.nome_vendedor FROM nota_antiga;

INSERT INTO cliente(nome, cpf, endereco)
SELECT DISTINCT nota_antiga.nome_cliente, nota_antiga.cpf_cliente, nota_antiga.ds_endereco_cliente FROM nota_antiga;

INSERT INTO produto(idProduto, descricao, unidade, preco)
SELECT DISTINCT
    codigo_produto,
    descricao_produto,
    unidade,
    preco
FROM (
    SELECT cd_prod1 AS codigo_produto, ds_prod1 AS descricao_produto, unidade1 AS unidade, preco1 AS preco
    FROM nota_antiga WHERE cd_prod1 IS NOT NULL

    UNION ALL

    SELECT cd_prod2, ds_prod2, unidade2, preco2
    FROM nota_antiga WHERE cd_prod2 IS NOT NULL

    UNION ALL

    SELECT cd_prod3, ds_prod3, unidade3, preco3
    FROM nota_antiga WHERE cd_prod3 IS NOT NULL

    UNION ALL

    SELECT cd_prod4, ds_prod4, unidade4, preco4
    FROM nota_antiga WHERE cd_prod4 IS NOT NULL
) AS produtos_extraidos;

INSERT INTO nota(idCliente, idVendedor, num_nota, data_emissao, valorTotal)
SELECT DISTINCT
    cliente.idCliente,
    vendedor.idVendedor,
    nota_antiga.nr_nota,
    nota_antiga.data_emissao,
    nota_antiga.vl_total1 + nota_antiga.vl_total2 + nota_antiga.vl_total3 + nota_antiga.vl_total4 AS vl_total
FROM
    nota_antiga
LEFT JOIN cliente ON cliente.nome = nota_antiga.nome_cliente
LEFT JOIN vendedor ON vendedor.nome = nota_antiga.nome_vendedor;

INSERT INTO item_nota(idNota, idProd, quantidade, preco)
SELECT DISTINCT
    n.idNota,
    p.codigo_produto,
    p.quantidade,
    p.preco
FROM (
    SELECT nr_nota, cd_prod1 AS codigo_produto, quantidade1 AS quantidade, preco1 AS preco FROM nota_antiga WHERE cd_prod1 IS NOT NULL
    UNION ALL
    SELECT nr_nota, cd_prod2, quantidade2, preco2 FROM nota_antiga WHERE cd_prod2 IS NOT NULL
    UNION ALL
    SELECT nr_nota, cd_prod3, quantidade3, preco3 FROM nota_antiga WHERE cd_prod3 IS NOT NULL
    UNION ALL
    SELECT nr_nota, cd_prod4, quantidade4, preco4 FROM nota_antiga WHERE cd_prod4 IS NOT NULL
) AS p
INNER JOIN nota n ON n.num_nota = p.nr_nota;
```
