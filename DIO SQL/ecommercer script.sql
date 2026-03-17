-- Criar banco
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- =========================
-- CLIENTE
-- =========================
CREATE TABLE cliente (
    idcliente INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_cliente ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    tipo_cliente ENUM('PF', 'PJ') NOT NULL
);

-- =========================
-- CLIENTE PF
-- =========================
CREATE TABLE cliente_pf (
    idcliente INT PRIMARY KEY,
    primeiro_nome VARCHAR(50) NOT NULL,
    ultimo_nome VARCHAR(50) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    dt_nasc DATE NOT NULL,
    sexo ENUM('f', 'm') NOT NULL,
    FOREIGN KEY (idcliente) REFERENCES cliente(idcliente)
);

-- =========================
-- CLIENTE PJ
-- =========================
CREATE TABLE cliente_pj (
    idcliente INT PRIMARY KEY,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    razao_social VARCHAR(100) NOT NULL,
    inscricao_estadual VARCHAR(20) NOT NULL UNIQUE,
    nome_fantasia VARCHAR(100) NOT NULL,
    FOREIGN KEY (idcliente) REFERENCES cliente(idcliente)
);

-- =========================
-- TELEFONE
-- =========================
CREATE TABLE telefone (
    idtelefone INT AUTO_INCREMENT PRIMARY KEY,
    cliente_idcliente INT,
    numero VARCHAR(20) UNIQUE,
    tipo ENUM('celular', 'residencial', 'comercial') NOT NULL,
    FOREIGN KEY (cliente_idcliente) REFERENCES cliente(idcliente)
);

-- =========================
-- CATEGORIA
-- =========================
CREATE TABLE categoria (
    idcategoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(45) NOT NULL UNIQUE,
    categoria_pai INT,
    FOREIGN KEY (categoria_pai) REFERENCES categoria(idcategoria)
);

-- =========================
-- PRODUTO
-- =========================
CREATE TABLE produto (
    idproduto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL,
    descricao VARCHAR(100),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_produto ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    categoria_idcategoria INT,
    FOREIGN KEY (categoria_idcategoria) REFERENCES categoria(idcategoria)
);

-- =========================
-- PEDIDO
-- =========================
CREATE TABLE pedido (
    idpedido INT AUTO_INCREMENT PRIMARY KEY,
    status_pedido ENUM('criado', 'cancelado', 'finalizado') DEFAULT 'criado',
    frete DECIMAL(10,2) NOT NULL,
    valor_total DECIMAL(10,2),
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    cliente_idcliente INT,
    FOREIGN KEY (cliente_idcliente) REFERENCES cliente(idcliente)
);

-- =========================
-- PRODUTO HAS PEDIDO
-- =========================
CREATE TABLE produto_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_idproduto INT,
    pedido_idpedido INT,
    quantidade INT,
    FOREIGN KEY (produto_idproduto) REFERENCES produto(idproduto),
    FOREIGN KEY (pedido_idpedido) REFERENCES pedido(idpedido)
);

-- =========================
-- ESTOQUE
-- =========================
CREATE TABLE estoque (
    idestoque INT AUTO_INCREMENT PRIMARY KEY,
    local_estoque VARCHAR(45)
);

CREATE TABLE produto_estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_idproduto INT,
    estoque_idestoque INT,
    quantidade INT,
    FOREIGN KEY (produto_idproduto) REFERENCES produto(idproduto),
    FOREIGN KEY (estoque_idestoque) REFERENCES estoque(idestoque)
);

-- =========================
-- PAGAMENTO
-- =========================
CREATE TABLE tipo_pagamento (
    idtipo_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(45)
);

CREATE TABLE pagamento (
    idpagamento INT AUTO_INCREMENT PRIMARY KEY,
    metodo_pagamento ENUM('cartao_credito', 'cartao_debito', 'boleto', 'pix') NOT NULL,
    status_pagamento ENUM('pago', 'cancelado', 'pendente'),
    pedido_idpedido INT,
    tipo_pagamento_id INT,
    FOREIGN KEY (pedido_idpedido) REFERENCES pedido(idpedido),
    FOREIGN KEY (tipo_pagamento_id) REFERENCES tipo_pagamento(idtipo_pagamento)
);

-- =========================
-- ENTREGA
-- =========================
CREATE TABLE entrega (
    identrega INT AUTO_INCREMENT PRIMARY KEY,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE entrega_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_idpedido INT,
    entrega_identrega INT,
    codigo_rastreio VARCHAR(20) UNIQUE,
    status_entrega ENUM('em_separacao', 'aguardando_separacao', 'em_rota', 'tentativa_entrega', 'entregue', 'cancelado'),
    data_envio DATETIME,
    FOREIGN KEY (pedido_idpedido) REFERENCES pedido(idpedido),
    FOREIGN KEY (entrega_identrega) REFERENCES entrega(identrega)
);

-- =========================
-- FORNECEDOR
-- =========================
CREATE TABLE fornecedor (
    idfornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome_fantasia VARCHAR(100)
);

CREATE TABLE fornecedor_produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fornecedor_id INT,
    produto_id INT,
    preco_compra DECIMAL(10,2),
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(idfornecedor),
    FOREIGN KEY (produto_id) REFERENCES produto(idproduto)
);

-- =========================
-- TERCEIRO VENDEDOR
-- =========================
CREATE TABLE terceiro_vendedor (
    idterceiro_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    localidade VARCHAR(100)
);

CREATE TABLE pedido_terceiro_vendedor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT,
    terceiro_id INT,
    valor_venda DECIMAL(10,2),
    comissao DECIMAL(10,2),
    FOREIGN KEY (pedido_id) REFERENCES pedido(idpedido),
    FOREIGN KEY (terceiro_id) REFERENCES terceiro_vendedor(idterceiro_vendedor)
);

-- =========================
-- VER TABELAS
-- =========================
SHOW tables;