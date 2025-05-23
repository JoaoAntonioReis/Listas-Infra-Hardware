.data
 	
 	result_perfect_square: .word 0
 	result_not_perfect: .word 0
 	b: .word 0
.text
	la $s0, b #carrega o endereço de "b"
	lw $s3, b #carrega o valor de "b"
	
	la $s1, result_perfect_square #carrega o endereço de "result_perfect_square"
	lw $s4, result_perfect_square #carrega o valor de "result_perfect_square"
	
	la $s2, result_not_perfect #carrega o endereço de "result_not_perfect"
	lw $s5, result_not_perfect #carrega o valor de "result_not_perfect"
	
	li $v0, 5 #leitura do "a"
	syscall
	
	move $t2, $v0 #move o conteudo de a para o registrador $t2
	
	
	move $t0, $zero #Esse será o "i" inicial = 0
	
	for:
		beq $t0, 10, quadrado_imperfeito #caso chegue a 10 interações o laço é encerrado
		addi $t0, $t0, 1 #adiciona 1 a cada interação
		mul  $t1, $t0, $t0 #calcula o quadrado
		
		beq $t1, $t2, quadrado_perfeito
		
		j for	#retorna para a função do "for"
		
	quadrado_imperfeito: #como nenhum número corresponde ao quadrado perfeito, o valor de "perfect_not_square" é alterado para o valor de 1

	
		move $s5, $t2 
		
		li $v0, 10 #encerra o programa
		syscall
	
	quadrado_perfeito:
		
		addi $s6, $s3, 1 #adiciona 1 ao "b" e salva no registrador $s6
		move $s3, $s6 #retorna o valor para o registrador $s3
		
		move $s4, $t2 #move o valor de "a" para "result_perfect_square"
		
		li $v0, 10 #encerra o programa
		syscall
	
	
	 
	
