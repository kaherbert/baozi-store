package br.com.baozistore.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import br.com.baozistore.model.Cliente;

/**
 * Basta declarar a interface: o Spring Data JPA cria sozinho a implementação com
 * save(), findById(), findAll(), deleteById(), existsById() etc.
 */
public interface ClienteRepository extends JpaRepository<Cliente, Long> {
}
