-- Verificar quantos clientes de cada tipo foram criados
SELECT tipo_cliente, COUNT(*) FROM cliente GROUP BY tipo_cliente;

-- Verificar o valor total de stock por local
SELECT e.local_estoque, SUM(pe.quantidade) as total_itens
FROM estoque e
JOIN produto_estoque pe ON e.idestoque = pe.estoque_idestoque
GROUP BY e.local_estoque;

-- Ver os pedidos e os seus respectivos pagamentos
SELECT p.idpedido, c.email, p.valor_total, pag.metodo_pagamento, pag.status_pagamento
FROM pedido p
JOIN cliente c ON p.cliente_idcliente = c.idcliente
JOIN pagamento pag ON p.idpedido = pag.pedido_idpedido;

-- conta o total de pedidos finalizados por cliente
SELECT 
    c.idcliente, c.tipo_cliente,
    COALESCE(pf.primeiro_nome, pj.razao_social) AS identificacao, 
    COUNT(p.idpedido) AS total_pedidos
FROM cliente c
LEFT JOIN cliente_pf pf ON c.idcliente = pf.idcliente
LEFT JOIN cliente_pj pj ON c.idcliente = pj.idcliente
JOIN pedido p ON c.idcliente = p.cliente_idcliente
WHERE p.status_pedido = 'finalizado'
GROUP BY c.idcliente, pf.primeiro_nome, pj.razao_social
ORDER BY total_pedidos desc;

-- conta o total de pedidos que nao foram finalizados por cliente
SELECT 
    c.idcliente, c.tipo_cliente,
    COALESCE(pf.primeiro_nome, pj.razao_social) AS identificacao, 
    COUNT(p.idpedido) AS total_pedidos
FROM cliente c
LEFT JOIN cliente_pf pf ON c.idcliente = pf.idcliente
LEFT JOIN cliente_pj pj ON c.idcliente = pj.idcliente
JOIN pedido p ON c.idcliente = p.cliente_idcliente
WHERE p.status_pedido = 'criado'
GROUP BY c.idcliente, pf.primeiro_nome, pj.razao_social
ORDER BY total_pedidos desc;

-- curva ABC dos produtos
SELECT 
    pr.nome, 
    SUM(pp.quantidade) AS total_vendido, 
    SUM(pp.quantidade * pr.preco_venda) AS faturamento_total
FROM produto pr
JOIN produto_pedido pp ON pr.idproduto = pp.produto_idproduto
JOIN pedido p ON pp.pedido_idpedido = p.idpedido
WHERE p.status_pedido = 'finalizado'
GROUP BY pr.idproduto
ORDER BY faturamento_total DESC;

-- alerta dfe estoque baixo

SELECT 
    p.nome AS produto, 
    e.local_estoque, 
    pe.quantidade AS qtd_atual,
    f.nome_fantasia AS fornecedor_principal
FROM produto p
JOIN produto_estoque pe ON p.idproduto = pe.produto_idproduto
JOIN estoque e ON pe.estoque_idestoque = e.idestoque
JOIN fornecedor_produto fp ON p.idproduto = fp.produto_id
JOIN fornecedor f ON fp.fornecedor_id = f.idfornecedor
WHERE pe.quantidade < 50
ORDER BY pe.quantidade ASC;

-- ticket medio, tipo de cliente que gasta mais por pedido

SELECT 
    c.tipo_cliente, 
    ROUND(AVG(p.valor_total), 2) AS ticket_medio,
    COUNT(p.idpedido) AS qtd_pedidos
FROM cliente c
JOIN pedido p ON c.idcliente = p.cliente_idcliente
WHERE p.status_pedido = 'finalizado'
GROUP BY c.tipo_cliente;

-- relacao metodo de pagamento x status de pagamento
SELECT 
    metodo_pagamento, 
    status_pagamento, 
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM pagamento), 2) AS porcentagem_total
FROM pagamento
GROUP BY metodo_pagamento, status_pagamento
ORDER BY metodo_pagamento, total DESC;