# Baozi Store – API REST

API REST simples para controlar **clientes**, **produtos** e **pedidos** da Baozi Store (loja de pãozinho chinês).

**Tecnologias:** Java 17+, Spring Boot 3.5, Spring Data JPA, Banco H2 (em memória), Maven (com Maven Wrapper), JSON.
**Arquitetura (MVC do Spring):** `model` → `repository` → `controller`.

## Como executar

Pré-requisito: JDK 17 ou superior (`java -version`).

```
# Linux / macOS
./mvnw spring-boot:run

# Windows
mvnw.cmd spring-boot:run
```

A API sobe em `http://localhost:8080`. Console do banco H2: `http://localhost:8080/h2-console`
(JDBC URL: `jdbc:h2:mem:baozidb` · usuário: `sa` · senha: em branco).

Para rodar o teste automatizado: `./mvnw test` (ou `mvnw.cmd test`).

No Eclipse: **Run As → Java Application** na classe `BaoziStoreApplication`.

## Estrutura

```
src/main/java/br/com/baozistore
├── BaoziStoreApplication.java
├── model         Cliente, Produto, Pedido        (entidades JPA)
├── repository    ClienteRepository, ProdutoRepository, PedidoRepository
└── controller    ClienteController, ProdutoController, PedidoController
src/main/resources/application.properties         (configuração do H2 e do JPA)
src/test/java/br/com/baozistore                    (teste automatizado)
```

## Entidades

| Entidade | Campos |
|----------|--------|
| Cliente  | `id` (Long), `nome` (String), `clienteDesde` (LocalDate) |
| Produto  | `id` (Long), `nome` (String), `preco` (BigDecimal), `estoque` (Boolean) |
| Pedido   | `id` (Long), `clienteId` (Long), `produtoId` (Long), `quantidade` (Integer) |

## Endpoints

| Método | Rota | Descrição | Sucesso |
|--------|------|-----------|---------|
| POST   | `/clientes`      | Criar cliente           | 201 |
| GET    | `/clientes/{id}` | Consultar cliente       | 200 |
| GET    | `/clientes`      | Listar clientes         | 200 |
| DELETE | `/clientes/{id}` | Apagar cliente          | 204 |
| POST   | `/produtos`      | Criar produto           | 201 |
| GET    | `/produtos/{id}` | Consultar produto       | 200 |
| GET    | `/produtos`      | Listar produtos         | 200 |
| DELETE | `/produtos/{id}` | Apagar produto          | 204 |
| POST   | `/pedidos`       | Criar pedido            | 201 |
| GET    | `/pedidos/{id}`  | Consultar pedido        | 200 |
| GET    | `/pedidos`       | Listar pedidos          | 200 |
| DELETE | `/pedidos/{id}`  | Apagar pedido           | 204 |

Erros: `400` (dados inválidos ou cliente/produto inexistente no pedido), `404` (id não encontrado),
`409` (tentar apagar cliente/produto que já possui pedidos).

## Exemplos de JSON

```json
// POST /clientes
{ "nome": "Kaherbert5125708", "clienteDesde": "2026-11-21" }

// POST /produtos
{ "nome": "Baozi de Carne", "preco": 8.50, "estoque": true }

// POST /pedidos
{ "clienteId": 1, "produtoId": 1, "quantidade": 3 }
```
