.data
# Coloque os valores de 'a' e 'b' aqui
#a_val: .word 7   # Exemplo de valor para 'a'
#b_val: .word 3   # Exemplo de valor para 'b'

# Para testar o caso de 'a' negativo:
 a_val: .word -5
 b_val: .word 3

.text
.globl main

main:
    # Carregar 'a' e 'b' da memória para registradores
    lw   $s0, a_val  # $s0 = a
    lw   $s1, b_val  # $s1 = b

    # Verificar se 'a' é negativo
    slt  $t0, $s0, $zero # $t0 = 1 se a < 0, caso contrário $t0 = 0
    bne  $t0, $zero, a_is_negative # Se a < 0 (ou seja, $t0 != 0), desviar para a_is_negative

    # Se 'a' não for negativo, prosseguir com o cálculo do módulo
    # Preparar argumentos para a função recursive_mod
    move $a0, $s0      # Argumento 0 (a) para a função
    move $a1, $s1      # Argumento 1 (b) para a função
    jal  recursive_mod # Chamar a função recursive_mod(a, b)
                       # O resultado será armazenado em $v0 pela função

    # O resultado de a mod b está em $v0.
    # O programa termina normalmente.
    j    exit_program

a_is_negative:
    # Se 'a' for negativo, armazenar 1 em $v1
    li   $v1, 1        # $v1 = 1
    # Encerrar o programa
    j    exit_program

exit_program:
    # Syscall para encerrar o programa
    li   $v0, 10       # Código de syscall para exit
    syscall

# -----------------------------------------------------------------------------
# Função: recursive_mod
# Descrição: Calcula (a mod b) recursivamente.
# Argumentos:
#   $a0: inteiro 'a' (assume-se a >= 0 na chamada desta função)
#   $a1: inteiro 'b' (assume-se b > 0 para a definição recursiva)
# Retorna:
#   $v0: o resultado de (a mod b)
# -----------------------------------------------------------------------------
recursive_mod:
    # $a0 contém o valor atual de 'a' para esta chamada recursiva
    # $a1 contém o valor de 'b'

    # Caso base da recursão: se a < b, então a mod b = a
    slt  $t0, $a0, $a1  # $t0 = 1 se a < b, caso contrário $t0 = 0
    beq  $t0, $zero, recur_step # Se a >= b (ou seja, $t0 == 0), desviar para recur_step

    # Se a < b (desvio não tomado):
    move $v0, $a0      # O resultado (a mod b) é 'a'
    jr   $ra           # Retornar para o chamador

recur_step:
    # Passo recursivo: se a >= b, então a mod b = (a-b) mod b

    # Salvar o endereço de retorno ($ra) na pilha, pois 'jal' o sobrescreverá
    addi $sp, $sp, -4  # Alocar espaço na pilha para uma palavra
    sw   $ra, 0($sp)   # Salvar $ra na pilha

    # Preparar o novo valor de 'a' para a chamada recursiva: a = a - b
    sub  $a0, $a0, $a1 # $a0 = $a0 - $a1 (novo 'a' = atual 'a' - 'b')
                       # $a1 ('b') permanece o mesmo

    jal  recursive_mod # Chamar recursivamente: recursive_mod(a-b, b)
                       # O resultado da chamada recursiva estará em $v0

    # Restaurar o endereço de retorno ($ra) da pilha
    lw   $ra, 0($sp)   # Restaurar $ra da pilha
    addi $sp, $sp, 4   # Desalocar o espaço na pilha

    # O resultado da chamada recursiva (que é o resultado final) já está em $v0.
    # Apenas retornar para o chamador.
    jr   $ra           # Retornar para o chamador
