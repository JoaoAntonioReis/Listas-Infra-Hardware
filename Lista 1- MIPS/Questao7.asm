.data
# Array de entrada 'a' e seu tamanho
# Ex.: a = [1,15,27,88,125,138]
array_a:      .word 1, 15, 27, 88, 125, 138
array_a_size: .word 6

# Array de saída 'b'
# Reserva espaço para o array_b. No pior caso, todos os elementos de 'a' são cubos perfeitos.
# O tamanho do array_a é 6 palavras, então 6 * 4 = 24 bytes.
array_b:      .space 24

.text
.globl main

main:
    # Carrega endereços base e tamanho
    la   $s0, array_a       # $s0 = endereço base do array_a
    la   $s1, array_b       # $s1 = endereço base do array_b
    lw   $s4, array_a_size  # $s4 = número de elementos no array_a

    # Inicializa índices
    li   $s2, 0             # i = 0 (índice para o array_a)
    li   $s3, 0             # k = 0 (índice para o array_b, e contador de elementos em b)

loop_through_a:
    # Condição do loop: se i >= array_a_size, então sai do loop
    slt  $t0, $s2, $s4      # $t0 = 1 se i < array_a_size, caso contrário $t0 = 0
    beq  $t0, $zero, end_loop_a # Se $t0 for 0 (i >= tamanho), desvia para end_loop_a

    # Calcula o endereço de a[i]: base_a + (i * 4)
    sll  $t1, $s2, 2        # $t1 = i * 4 (deslocamento em bytes)
    add  $t2, $s0, $t1      # $t2 = endereço de a[i]
    lw   $a0, 0($t2)        # $a0 = valor de a[i] (este é o número a ser verificado)

    # Chama a função is_perfect_cube
    # Salva $ra, pois jal o sobrescreve. $s0-$s4 são, por convenção, salvos pela função chamada (callee-saved).
    # Como is_perfect_cube usa apenas registradores $t (caller-saved), nossos registradores $s estão seguros.
    addi $sp, $sp, -4       # Aloca espaço na pilha
    sw   $ra, 0($sp)        # Salva o endereço de retorno

    jal  is_perfect_cube    # Chama is_perfect_cube(a[i]). O resultado estará em $v0.

    lw   $ra, 0($sp)        # Restaura o endereço de retorno
    addi $sp, $sp, 4        # Desaloca espaço na pilha

    # Verifica o resultado de is_perfect_cube ($v0)
    # Se $v0 for 0 (falso), não é um cubo perfeito, então pula a adição ao array_b
    beq  $v0, $zero, not_a_cube

    # Se $v0 for 1 (verdadeiro), a[i] é um cubo perfeito. Adiciona ao array_b.
    # O valor a[i] ainda está em $a0 desde que foi carregado.
    # Calcula o endereço de b[k]: base_b + (k * 4)
    sll  $t3, $s3, 2        # $t3 = k * 4 (deslocamento em bytes para array_b)
    add  $t4, $s1, $t3      # $t4 = endereço de b[k]
    sw   $a0, 0($t4)        # Armazena a[i] em b[k]

    addi $s3, $s3, 1        # Incrementa k (índice/contador para array_b)

not_a_cube:
    addi $s2, $s2, 1        # Incrementa i (índice para array_a)
    j    loop_through_a     # Volta para o início do loop

end_loop_a:
    # Processamento finalizado.
    # array_b agora contém todos os cubos perfeitos do array_a.
    # $s3 contém o número de elementos escritos no array_b.

    # Termina o programa
    li   $v0, 10            # Código da syscall para exit
    syscall

# -----------------------------------------------------------------------------
# Função: is_perfect_cube
# Descrição: Verifica se um dado inteiro não negativo é um cubo perfeito.
# Argumentos:
#   $a0: O inteiro 'n' para verificar (assume-se que está em [0, 10000]).
# Retorna:
#   $v0: 1 se 'n' for um cubo perfeito, 0 caso contrário.
# Usa registradores temporários $t0-$t4.
# -----------------------------------------------------------------------------
is_perfect_cube:
    # $a0 = n (número a ser verificado)

    # Trata n = 0 separadamente: 0*0*0 = 0, que é um cubo perfeito.
    beq  $a0, $zero, return_is_cube_true 

    # Itera x a partir de 1. Como o n máximo é 10000:
    # 21^3 = 9261
    # 22^3 = 10648 (este é > 10000)
    # Então, precisamos verificar x até 21.
    li   $t0, 1          # $t0 = x (nossa raiz cúbica potencial, começando em 1)
    li   $t3, 22         # Loop enquanto x < 22 (ou seja, x <= 21)

check_loop_iscube:
    # Calcula cubo_atual = x * x * x
    mul  $t1, $t0, $t0   # $t1 = x * x
    mul  $t2, $t1, $t0   # $t2 = x * x * x (cubo_atual)

    # Compara cubo_atual com n ($a0)
    beq  $t2, $a0, return_is_cube_true  # Se cubo_atual == n, então n é um cubo perfeito

    # Se cubo_atual > n, então n não pode ser um cubo perfeito com raiz x ou maior,
    # porque a função cúbica é monotonicamente crescente para x > 0.
    slt  $t4, $a0, $t2   # $t4 = 1 se n < cubo_atual (ou seja, cubo_atual > n)
    bne  $t4, $zero, return_is_cube_false # Se $t4 for 1, desvia

    # Incrementa x e continua o loop se x ainda estiver dentro do intervalo
    addi $t0, $t0, 1     # x = x + 1
    blt  $t0, $t3, check_loop_iscube # Se x < 22, continua o loop

    # Se o loop terminar, significa que nenhum x produziu n, e nenhum cubo excedeu n prematuramente
    # (o que significa que n é maior que o maior cubo que verificaríamos, ou simplesmente não é um cubo).
    # Este caminho implica que n não é um cubo perfeito dentro do intervalo verificado de x.
return_is_cube_false:
    li   $v0, 0          # Define o valor de retorno para 0 (falso)
    jr   $ra             # Retorna ao chamador

return_is_cube_true:
    li   $v0, 1          # Define o valor de retorno para 1 (verdadeiro)
    jr   $ra             # Retorna ao chamador
