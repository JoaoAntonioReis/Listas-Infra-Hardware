li $v0, 5 #Le valor do segundo inteiro
	syscall

	
	move $t1, $v0 #move o valor do segundo inteiro para o registrador t1


	blt $t0, $t1, menor
	bgt $t0, $t1, maior
	add $t2, $t0, $t1
	syscall
	menor: 
		
		move $t2, $t1
		syscall
	maior: 
		
		move $t2, $t0
		syscall
