.data
dividendo:  .word   17     # Número a ser dividido (pode ser positivo ou negativo)
divisor:    .word   5       # Divisor (pode ser positivo ou negativo)
RESULT:     .word   0       # Quociente da divisão
REMAINDER:  .word   0       # Resto da divisão

.text
.globl main

main:
    # Carrega os valores da memória
    lw $t0, dividendo       # $t0 = dividendo
    lw $t1, divisor         # $t1 = divisor

    # Inicializa registradores
    li $t2, 0               # $t2 = quociente (inicializado com 0)
    li $t3, 0               # $t3 = sinal do quociente (0=positivo, 1=negativo)
    li $t4, 0               # $t4 = sinal do resto (0=positivo, 1=negativo)

    # Verifica se o dividendo é negativo
    bgez $t0, check_divisor
    abs $t0, $t0            # Pega valor absoluto do dividendo
    li $t4, 1               # Resto será negativo (mesmo sinal do dividendo)
    li $t3, 1               # Inverte sinal do quociente

check_divisor:
    # Verifica se o divisor é negativo
    bgez $t1, divisao_loop
    abs $t1, $t1            # Pega valor absoluto do divisor
    xori $t3, $t3, 1        # Inverte sinal do quociente (XOR com 1)

divisao_loop:
    # Subtrai divisor do dividendo até que dividendo < divisor
    blt $t0, $t1, end_loop
    sub $t0, $t0, $t1       # Subtrai divisor do dividendo
    addi $t2, $t2, 1        # Incrementa quociente
    j divisao_loop

end_loop:
    # $t0 agora contém o resto (valor absoluto)
    # Ajusta o sinal do quociente se necessário
    beqz $t3, save_result
    neg $t2, $t2            # Quociente negativo

save_result:
    # Ajusta o sinal do resto se necessário
    beqz $t4, save_remainder
    neg $t0, $t0            # Resto negativo

save_remainder:
    # Armazena RESULT (quociente) e REMAINDER (resto) na memória
    sw $t2, RESULT
    sw $t0, REMAINDER

    # Finaliza o programa
    li $v0, 10
    syscall
