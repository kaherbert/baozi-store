package br.com.baozistore.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import br.com.baozistore.model.Pedido;

public interface PedidoRepository extends JpaRepository<Pedido, Long> {

    // "Query methods": o Spring Data monta o SQL só pelo nome do método.
    // Usados para impedir apagar um cliente/produto que já tem pedidos.
    boolean existsByClienteId(Long clienteId);

    boolean existsByProdutoId(Long produtoId);
}
