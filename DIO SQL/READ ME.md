# DIO_SQL

O projeto consiste em:
* Script para criar o schema e suas tabelas
* Script de consultas
* Código python para popular dados no BD
* Modelo EER do projeto

🛒 Projeto Banco de Dados - E-commerce
📌 Descrição

Este projeto consiste na modelagem e implementação de um banco de dados para um sistema de e-commerce, desenvolvido utilizando o MySQL.

O banco foi projetado a partir de um Diagrama EER (Enhanced Entity-Relationship), com foco em boas práticas de modelagem relacional, integridade dos dados e escalabilidade.

🎯 Objetivo

Criar uma estrutura de banco de dados capaz de representar as principais entidades de um sistema de e-commerce, como clientes, produtos, pedidos e pagamentos, garantindo consistência e organização dos dados.

🧠 Modelagem

A modelagem foi realizada utilizando o modelo EER, permitindo representar:

Entidades e seus atributos

Relacionamentos (1:1, 1 e N)

Especializações (Cliente PF e PJ)

Integridade referencial com chaves estrangeiras

🏗️ Estrutura do Banco

O banco de dados é composto pelas seguintes tabelas principais:

cliente

cliente_pf

cliente_pj

produto

categoria

pedido

item_pedido

pagamento

🔗 Relacionamentos

Alguns dos principais relacionamentos implementados:

Um cliente pode realizar vários pedidos (1)

Um pedido pode conter vários produtos (N, resolvido com a tabela item_pedido)

Um produto pertence a uma categoria (1)

Um cliente pode ter múltiplas formas de pagamento (1)

Especialização de cliente em PF (Pessoa Física) e PJ (Pessoa Jurídica)
