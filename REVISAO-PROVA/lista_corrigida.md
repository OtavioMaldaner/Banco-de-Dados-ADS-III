# Exercícios subconsultas

## 1. Liste os nomes dos funcionários que recebem salário maior que o salário do funcionário chamado 'João'.

```sql
SELECT Pnome, Unome
FROM funcionario
WHERE Salario > (
  SELECT Salario
  FROM funcionario
  WHERE Pnome = 'João'
);
```

## 2. Mostre o nome e salário dos funcionários cujo salário seja maior que a média salarial do departamento 'Administração'.

```sql
SELECT f.Pnome, f.Unome, f.Salario
FROM funcionario f
WHERE f.Salario > (
  SELECT AVG(f2.Salario)
  FROM funcionario f2
  JOIN departamento d ON f2.Dnr = d.Dnumero
  WHERE d.Dnome = 'Administração'
);
```

## 3. Exiba o nome dos departamentos cujo número de funcionários é igual ao número de projetos que ele gerencia.

```sql
SELECT d.Dnome
FROM departamento d
WHERE (
  SELECT COUNT(*)
  FROM funcionario f
  WHERE f.Dnr = d.Dnumero
) = (
  SELECT COUNT(*)
  FROM projeto p
  WHERE p.Dnum = d.Dnumero
);
```

## 4. Exibir os nomes dos projetos nos quais não há nenhum funcionário que tenha o mesmo sobrenome que o gerente do departamento do projeto.

```sql
SELECT p.Projnome
FROM projeto p
WHERE p.Projnumero NOT IN (
    SELECT t.Pnr
    FROM trabalha_em t
    JOIN funcionario f ON t.Fcpf = f.Cpf
    JOIN projeto pr ON t.Pnr = pr.Projnumero
    JOIN departamento d ON pr.Dnum = d.Dnumero
    JOIN funcionario g ON d.Cpf_gerente = g.Cpf
    WHERE f.Unome = g.Unome
);
```

## 5. Mostre os nomes dos funcionários que trabalham nos mesmos projetos que o funcionário chamado 'Alice', mas que não sejam a própria Alice.

```sql
SELECT DISTINCT f.Pnome, f.Unome
FROM funcionario f
JOIN trabalha_em te ON f.Cpf = te.Fcpf
WHERE te.Pnr IN (
  SELECT te2.Pnr
  FROM trabalha_em te2
  JOIN funcionario f2 ON te2.Fcpf = f2.Cpf
  WHERE f2.Pnome = 'Alice'
)
AND f.Pnome <> 'Alice';
```

## 6. Liste o nome dos funcionários que trabalham nos mesmos projetos e com a mesma carga horária que outro funcionário chamado 'Fernando'.

```sql
SELECT f.Pnome, f.Unome
FROM funcionario f
JOIN trabalha_em te ON f.Cpf = te.Fcpf
WHERE (te.Pnr, te.Horas) IN (
  SELECT te2.Pnr, te2.Horas
  FROM trabalha_em te2
  JOIN funcionario f2 ON te2.Fcpf = f2.Cpf
  WHERE f2.Pnome = 'Fernando'
)
AND f.Pnome <> 'Fernando';
```

## 7. Para cada departamento, exiba: Nome do departamento, Total de funcionários e Média salarial.

Use uma subconsulta no FROM para calcular a média salarial por departamento.

```sql
SELECT d.Dnome AS departamento,
       dados.total_funcionarios,
       dados.media_salarial
FROM (
  SELECT Dnr,
         COUNT(*) AS total_funcionarios,
         AVG(Salario) AS media_salarial
  FROM funcionario
  GROUP BY Dnr
) AS dados
JOIN departamento d ON dados.Dnr = d.Dnumero;
```

## 8. Liste os nomes dos funcionários cujo salário é acima da média salarial de seu departamento, e que não possuem dependentes.

```sql
SELECT f.Pnome, f.Unome, f.Salario
FROM (
  SELECT Dnr, AVG(Salario) AS media_salarial
  FROM funcionario
  GROUP BY Dnr
) AS medias
JOIN funcionario f ON f.Dnr = medias.Dnr
WHERE f.Salario > medias.media_salarial
  AND f.Cpf NOT IN (
    SELECT Fcpf
    FROM dependente
  );
```

## 9. Para cada departamento, exiba: Nome do departamento e quantidade de funcionários que possuem salário maior que a média salarial dos funcionários com dependentes.

```sql
SELECT d.Dnome AS departamento,
       COUNT(f.Cpf) AS funcionarios_acima_da_media
FROM funcionario f
JOIN departamento d ON f.Dnr = d.Dnumero
WHERE f.Salario > (
  SELECT AVG(f2.Salario)
  FROM funcionario f2
  WHERE f2.Cpf IN (
    SELECT DISTINCT Fcpf
    FROM dependente
  )
)
GROUP BY d.Dnome;
```
