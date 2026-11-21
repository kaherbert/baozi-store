package br.com.baozistore.controller;

import java.net.URI;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import br.com.baozistore.model.Cliente;
import br.com.baozistore.repository.ClienteRepository;
import br.com.baozistore.repository.PedidoRepository;
import jakarta.validation.Valid;

/**
 * Endpoints de Cliente (base: /clientes)
 *
 *   POST   /clientes        -> criar
 *   GET    /clientes/{id}   -> consultar por id
 *   GET    /clientes        -> listar todos
 *   DELETE /clientes/{id}   -> apagar
 */
@RestController
@RequestMapping("/clientes")
public class ClienteController {

    private final ClienteRepository clienteRepository;
    private final PedidoRepository pedidoRepository;

    // Injeção de dependência: o Spring entrega os repositórios prontos
    public ClienteController(ClienteRepository clienteRepository, PedidoRepository pedidoRepository) {
        this.clienteRepository = clienteRepository;
        this.pedidoRepository = pedidoRepository;
    }

    // POST /clientes  -> responde 201 Created com o cliente salvo (já com o id)
    @PostMapping
    public ResponseEntity<Cliente> criar(@Valid @RequestBody Cliente cliente) {
        cliente.setId(null); // garante que será um cadastro novo, nunca uma alteração
        Cliente salvo = clienteRepository.save(cliente);

        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(salvo.getId())
                .toUri();
        return ResponseEntity.created(location).body(salvo);
    }

    // GET /clientes/{id}  -> 200 OK ou 404 Not Found
    @GetMapping("/{id}")
    public Cliente buscarPorId(@PathVariable Long id) {
        return clienteRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Cliente não encontrado com id " + id));
    }

    // GET /clientes  -> 200 OK com a lista (vazia se não houver clientes)
    @GetMapping
    public List<Cliente> listarTodos() {
        return clienteRepository.findAll();
    }

    // DELETE /clientes/{id}  -> 204 No Content, 404 ou 409 (se já tiver pedidos)
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> apagar(@PathVariable Long id) {
        if (!clienteRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Cliente não encontrado com id " + id);
        }
        if (pedidoRepository.existsByClienteId(id)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Não é possível apagar: o cliente possui pedidos. Apague os pedidos primeiro.");
        }
        clienteRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
