-- CRIAÇÃO DO ESQUEMA E-COMMERCE
CREATE DATABASE ecommerce;
USE ecommerce;

-- TABELA CLIENTE
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco VARCHAR(255)
);

-- TABELA CLIENTE PF
CREATE TABLE cliente_pf (
    id_cliente INT PRIMARY KEY,
    cpf CHAR(11) UNIQUE NOT NULL,
    data_nascimento DATE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- TABELA CLIENTE PJ
CREATE TABLE cliente_pj (
    id_cliente INT PRIMARY KEY,
    cnpj CHAR(14) UNIQUE NOT NULL,
    razao_social VARCHAR(100),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- TABELA VENDEDOR
CREATE TABLE vendedor (
    id_vendedor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    telefone VARCHAR(20),
    email VARCHAR(100)
);

-- TABELA FORNECEDOR
CREATE TABLE fornecedor (
    id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    contato VARCHAR(100)
);

-- TABELA PRODUTO
CREATE TABLE produto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    descricao TEXT,
    preco DECIMAL(10,2),
    id_fornecedor INT,
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
);

-- TABELA ESTOQUE
CREATE TABLE estoque (
    id_estoque INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT,
    quantidade INT,
    local VARCHAR(100),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- TABELA PEDIDO
CREATE TABLE pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    data_pedido DATE,
    status VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- TABELA ENTREGA
CREATE TABLE entrega (
    id_entrega INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    codigo_rastreamento VARCHAR(100),
    status_entrega VARCHAR(50),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);

-- TABELA ITEM_PEDIDO
CREATE TABLE item_pedido (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    id_produto INT,
    quantidade INT,
    preco_unitario DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- TABELA PAGAMENTO
CREATE TABLE pagamento (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    forma_pagamento VARCHAR(50),
    valor DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);

-- DADOS DE TESTE
INSERT INTO cliente (nome, telefone, email, endereco) VALUES
('Maria Silva', '11999999999', 'maria@email.com', 'Rua A, 100'),
('Loja do João', '1122222222', 'contato@lojajoao.com', 'Av B, 200');

INSERT INTO cliente_pf (id_cliente, cpf, data_nascimento) VALUES
(1, '12345678901', '1995-04-12');

INSERT INTO cliente_pj (id_cliente, cnpj, razao_social) VALUES
(2, '12345678000199', 'Loja do João LTDA');

INSERT INTO fornecedor (nome, contato) VALUES
('Fornecedor A', 'contato@fornA.com'),
('Fornecedor B', 'contato@fornB.com');

INSERT INTO produto (nome, descricao, preco, id_fornecedor) VALUES
('Teclado Mecânico', 'Switch Azul', 250.00, 1),
('Mouse Gamer', 'RGB 12000 DPI', 150.00, 2);

INSERT INTO estoque (id_produto, quantidade, local) VALUES
(1, 5, 'Galpão 1'),
(2, 15, 'Galpão 2');

INSERT INTO pedido (id_cliente, data_pedido, status) VALUES
(1, '2025-07-01', 'Processando'),
(2, '2025-07-02', 'Enviado');

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 250.00),
(1, 2, 1, 150.00),
(2, 2, 3, 150.00);

INSERT INTO pagamento (id_pedido, forma_pagamento, valor) VALUES
(1, 'Cartão de Crédito', 650.00),
(2, 'Boleto', 450.00);

INSERT INTO entrega (id_pedido, codigo_rastreamento, status_entrega) VALUES
(1, 'BR1234567890BR', 'Em trânsito'),
(2, 'BR9876543210BR', 'Entregue');

-- CONSULTAS SQL COMPLEXAS

-- 1. Quantos pedidos foram feitos por cada cliente
SELECT 
    c.nome, 
    COUNT(p.id_pedido) AS total_pedidos
FROM 
    cliente c
LEFT JOIN 
    pedido p ON c.id_cliente = p.id_cliente
GROUP BY 
    c.nome;

-- 2. Algum vendedor também é fornecedor?
SELECT 
    v.nome AS vendedor, 
    f.nome AS fornecedor
FROM 
    vendedor v
JOIN 
    fornecedor f ON v.nome = f.nome;

-- 3. Relação de produtos, fornecedores e estoques
SELECT 
    p.nome AS produto,
    f.nome AS fornecedor,
    e.quantidade,
    e.local
FROM 
    produto p
JOIN 
    fornecedor f ON p.id_fornecedor = f.id_fornecedor
JOIN 
    estoque e ON p.id_produto = e.id_produto;

-- 4. Produtos com estoque inferior a 10 unidades
SELECT 
    p.nome,
    e.quantidade
FROM 
    produto p
JOIN 
    estoque e ON p.id_produto = e.id_produto
WHERE 
    e.quantidade < 10
ORDER BY 
    e.quantidade ASC;

-- 5. Valor total de cada pedido
SELECT 
    p.id_pedido,
    c.nome,
    SUM(i.quantidade * i.preco_unitario) AS valor_total
FROM 
    pedido p
JOIN 
    cliente c ON p.id_cliente = c.id_cliente
JOIN 
    item_pedido i ON p.id_pedido = i.id_pedido
GROUP BY 
    p.id_pedido, c.nome
ORDER BY 
    valor_total DESC;

-- 6. Clientes com mais de 1 pedido
SELECT 
    c.nome,
    COUNT(p.id_pedido) AS total_pedidos
FROM 
    cliente c
JOIN 
    pedido p ON c.id_cliente = p.id_cliente
GROUP BY 
    c.nome
HAVING 
    COUNT(p.id_pedido) > 1;
