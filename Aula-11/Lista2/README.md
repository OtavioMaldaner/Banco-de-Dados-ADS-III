1) Considerando o banco de dados Empresa, selecionar o nome completo do funcionário, seu salário, um salário novo (considerando 20% de aumento), e uma coluna contendo os seguintes valores concatenados (separados por _ ) nesta ordem:
- as primeiras 3 letras do nome do departamento
- código do departamento
- as últimas 3 letras do nome do projeto
- o número do projeto
- nome do funcionário
- quarto, quinto, e sexto dígitos do CPF do funcionário
Considerando as seguintes restrições:
- somente dos funcionários que moram em São Paulo ou que tenham nascido na década de 60.
Apresentando os resultados ordenados em ordem decrescente.
Observação: apenas para deixar claro, caso o funcionário trabalhe em mais de um projeto, seu
nome e salário aparecerão em mais de uma linha no resultado.

```sql
SELECT
    CONCAT(
        funcionario.Pnome,
        " ",
        funcionario.Unome
    ) AS nome,
    funcionario.Salario,
    funcionario.Salario * 1.2 AS novo_salario,
    CONCAT_WS(
        "_",
        LEFT(departamento.Dnome, 3),
        departamento.Dnumero,
        RIGHT(departamento.Dnome, 3),
        projeto.Projnumero,
        funcionario.Pnome,
        SUBSTRING(funcionario.Cpf, 4, 3)
    ) AS coluna_extra
FROM
    funcionario
LEFT JOIN departamento ON departamento.Dnumero = funcionario.Dnr
LEFT JOIN projeto ON projeto.Dnum = departamento.Dnumero
WHERE
    funcionario.Endereco LIKE "%São Paulo%" OR funcionario.Datanasc LIKE "%196_-__-__%"
ORDER BY
    funcionario.Pnome
DESC 
```