.data
	
	tipo_triangulo: .asciiz 
	eq: .asciiz "eq"
	esc: .asciiz "esc"
	iso: .asciiz "iso"
	not_t: .asciiz "not"
	
	
.text
	

	li $s1, 3
	
	li $v0, 5 #le o lado 1
	syscall 
	
	move $a0, $v0 #guarda o valor do lado 1 no registrador $a0
	
	li $v0, 5 #le o lado 2
	syscall 
	
	move $a1, $v0 #guarda o valor do lado 2 no registrador $a1
	 
	li $v0, 5 #le o lado 3
	syscall 
	
	move $a2, $v0 #guarda o valor do lado 3 no registrador $a2
	
	
	checagem:
		
		add $t1, $a0, $a1
		blt $t1, $a2, Not_triangulo # checa se o lado(1+2) é menor que o lado 3
		
		
		add $t2, $a0, $a2
		blt $t2, $a1, Not_triangulo # checa se o lado(1+3) é menor que o lado 2
		
	
		add $t3, $a2, $a1
		blt $t3, $a0, Not_triangulo # checa se o lado(3+2) é menor que o lado 1
		
	
	equilatero_checagem:
		
		beq $a0, $a1, equilatero_checagem2
	
	isorceles_checagem:
	
		beq $a0, $a1, isorceles#checa se o lado 1 == lado 2
		
		beq $a0, $a2, isorceles#checa se o lado 1 == lado 3
		
		beq $a2, $a1, isorceles#checa se o lado 3 == lado 2
	
	escaleno: #caso não seja nunhum outro tipo de triangulo, entra nesse label
	
		la $s5, esc    # s5 aponta para "esc"
		la $s4, tipo_triangulo
		
		lb $t2, 0($s5)
		sb $t2, 0($s4)

		lb $t2, 1($s5)
		sb $t2, 1($s4)

		lb $t2, 2($s5)
		sb $t2, 2($s4)
				
		
		li $v0, 10
		syscall	
	
	equilatero_checagem2:
		
		
		beq $a1, $a2, equilatero
									
	isorceles:
   	 	la $s5, iso                
    		la $s4, tipo_triangulo     

    		lb $t2, 0($s5)
    		sb $t2, 0($s4)

    		lb $t2, 1($s5)
    		sb $t2, 1($s4)

    		lb $t2, 2($s5)
    		sb $t2, 2($s4)

    		lb $t2, 3($s5)             
    		sb $t2, 3($s4)

    		li $v0, 10                 
    		syscall

	
	equilatero:
		
		
    	la $s5, tipo_triangulo     
    	la $s4, eq                 

    	lb $t2, 0($s4)
    	sb $t2, 0($s5)

    	lb $t2, 1($s4)
    	sb $t2, 1($s5)

    	lb $t2, 2($s4)             
    	sb $t2, 2($s5)

   	li $v0, 10                 
    	syscall
	
	Not_triangulo:
    	la $s5, tipo_triangulo     
    	la $s4, not_t              

	lb $t2, 0($s4)
    	sb $t2, 0($s5)

    	lb $t2, 1($s4)
    	sb $t2, 1($s5)

    	lb $t2, 2($s4)
    	sb $t2, 2($s5)

    	lb $t2, 3($s4)             
    	sb $t2, 3($s5)

    	li $v0, 10                 
    	syscall

	

		
	
		
			
		
		
	
	
	
	
