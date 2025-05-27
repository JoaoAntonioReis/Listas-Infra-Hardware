.data
string:     .asciiz "enTRadA"   # String de entrada
VOWELS:     .asciiz "AEIOUaeiou" # Vogais maiúsculas e minúsculas para verificação

.text
.globl main

main:
    la $s0, string          # Carrega endereço da string em $s0
    li $v1, 0               # Inicializa $v1 (flag de erro)

    # Variáveis temporárias
    li $t7, 0               # Contador de vogais
    li $t8, 0               # Contador de caracteres processados

    # Buffer para reorganização (vogais + consoantes)
    li $t9, 0               # Índice do buffer

loop_check_char:
    lb $t0, 0($s0)          # Carrega caractere atual
    beqz $t0, reorder_string # Se NULL, termina a leitura

    # Verifica se é uma letra (A-Z ou a-z)
    jal is_letter
    beqz $v0, invalid_char  # Se não for letra, erro

    # Verifica se é vogal
    jal is_vowel
    beqz $v0, is_consonant  # Se não for vogal, trata como consoante

    # Transforma vogal em maiúscula
    jal to_upper
    sb $t0, 0($s0)          # Salva de volta na string
    addi $t7, $t7, 1        # Incrementa contador de vogais
    j next_char

is_consonant:
    # Transforma consoante em minúscula
    jal to_lower
    sb $t0, 0($s0)          # Salva de volta na string

next_char:
    addi $s0, $s0, 1        # Avança para o próximo caractere
    addi $t8, $t8, 1        # Incrementa contador total
    j loop_check_char

invalid_char:
    li $v1, 1               # Sinaliza erro (caractere inválido)
    j end_program

reorder_string:
    # Prepara para reorganizar (vogais primeiro, consoantes depois)
    la $s0, string          # Reinicia ponteiro
    li $t1, 0               # Índice para escrita

    # Primeiro passamos por todas as vogais
    li $t2, 0               # Contador de vogais escritas
    beqz $t7, write_consonants # Se não houver vogais, pula

loop_write_vowels:
    lb $t0, 0($s0)          # Carrega caractere
    beqz $t0, write_consonants # Se NULL, vai para consoantes
    jal is_vowel            # Verifica se é vogal
    beqz $v0, skip_vowel    # Se não for, pula
    sb $t0, buffer($t1)     # Salva no buffer (vogal)
    addi $t1, $t1, 1        # Incrementa índice do buffer
    addi $t2, $t2, 1        # Incrementa contador de vogais escritas
    beq $t2, $t7, write_consonants # Se todas as vogais foram escritas, vai para consoantes

skip_vowel:
    addi $s0, $s0, 1        # Próximo caractere
    j loop_write_vowels

write_consonants:
    la $s0, string          # Reinicia ponteiro
    li $t3, 0               # Contador de consoantes escritas

loop_write_consonants:
    lb $t0, 0($s0)          # Carrega caractere
    beqz $t0, copy_back     # Se NULL, termina
    jal is_vowel            # Verifica se é vogal
    bnez $v0, skip_consonant # Se for vogal, pula
    sb $t0, buffer($t1)     # Salva consoante no buffer
    addi $t1, $t1, 1        # Incrementa índice do buffer
    addi $t3, $t3, 1        # Incrementa contador de consoantes

skip_consonant:
    addi $s0, $s0, 1        # Próximo caractere
    j loop_write_consonants

copy_back:
    # Copia buffer de volta para a string original
    la $s0, string
    la $t4, buffer
    li $t5, 0               # Índice de cópia

loop_copy:
    lb $t0, 0($t4)          # Carrega do buffer
    beqz $t0, end_program   # Se NULL, termina
    sb $t0, 0($s0)          # Salva na string original
    addi $s0, $s0, 1
    addi $t4, $t4, 1
    j loop_copy

end_program:
    li $v0, 10              # Encerra o programa
    syscall

# --- Funções auxiliares ---
is_letter:
    # Verifica se $t0 é uma letra (A-Z, a-z)
    li $v0, 0               # Assume que não é letra
    blt $t0, 'A', not_letter
    ble $t0, 'Z', is_letter_true
    blt $t0, 'a', not_letter
    ble $t0, 'z', is_letter_true
    j not_letter

is_letter_true:
    li $v0, 1               # É letra
    jr $ra

not_letter:
    li $v0, 0
    jr $ra

is_vowel:
    # Verifica se $t0 é vogal (A, E, I, O, U, a, e, i, o, u)
    la $t6, VOWELS          # Carrega lista de vogais
    li $v0, 0               # Assume que não é vogal

check_vowel_loop:
    lb $t5, 0($t6)          # Carrega vogal da lista
    beqz $t5, end_vowel_check # Se NULL, termina
    beq $t0, $t5, vowel_found # Se for vogal, retorna 1
    addi $t6, $t6, 1        # Próxima vogal
    j check_vowel_loop

vowel_found:
    li $v0, 1

end_vowel_check:
    jr $ra

to_upper:
    # Converte $t0 para maiúscula (se for minúscula)
    blt $t0, 'a', upper_done
    bgt $t0, 'z', upper_done
    sub $t0, $t0, 32        # 'a' -> 'A' (diferença ASCII)
upper_done:
    jr $ra

to_lower:
    # Converte $t0 para minúscula (se for maiúscula)
    blt $t0, 'A', lower_done
    bgt $t0, 'Z', lower_done
    add $t0, $t0, 32        # 'A' -> 'a' (diferença ASCII)
lower_done:
    jr $ra

.data
buffer: .space 256          # Buffer temporário para reordenação
