.data
	b: .word 2
	res: .word 1
	
.text
	
	la $s0, b #carrega a o endereço de b para o registrador $s0
	lw $s2, b #carrega o conteudo de b para o registrador $s3
	
	la $s1, res #carrega a o endereço de b para o registrador $s1
	lw $s3, res #carrega o conteudo de b para o registrador $s4
	
	li $v0, 5 #le o valor de "e"
	syscall
	
	move $s4, $v0 #move o conteudo do input para o registrador $s5
	
	move $t0, $zero #"i" incial igual a 0 do laço "for"
	
	for:
	
		beq $s4, $t0, saida # caso o contador seja igual a o "i", o laço se encerra
		addi $t0, $t0, 1 #soma 1 para cada interação do laço
		mul $s3, $s3, $s2 #faz a multiplicação de "res" por "b"
		
		j for
	
	saida:
		
		li $v0, 10
		syscall
	
	#O resultado de "res" apos a pontenciaçãoe sta guardado em $s3
	
	
	
	
