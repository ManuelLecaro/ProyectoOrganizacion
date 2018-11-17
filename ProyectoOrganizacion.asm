.data
	inicio: .asciiz "Ingrese el flotante que desee representar en formato IEEE754 :\n"
	fin:   .asciiz "El resultado en formato IEEE-754 es:\n"
	bits32:.asciiz "32 bits:\n"
	bits64:.asciiz "64 bits:\n"
	zeroFlotante:.float 0.0

.text
	lwc1 $f4, zeroFlotante
	recepcion_numero:
		li $v0, 4
		la $a0, inicio
		syscall
		
		#Tomar el valor que ingrese el usuario
		li $v0,6
		syscall
		
		#mostrando mensajes de resultados
		li $v0, 4
		la $a0, fin
		syscall
		
		#mostrando mensaje de resultado para formato de 32 bits
		li $v0, 4
		la $a0, bits32
		syscall 
		
		#Mostrar bit de signo
		c.lt.d $f0, $f4        # CC = $f0 < $f2
        	bc1t NEGATIVO          # Branch if $f0 < $f2
        	nop
        	j POSITIVO
        
         #imprimiendo el bit de signo
        	NEGATIVO: li $v0,1			#$a0 se usa para imprimir int
        	  addi $a0,$zero,1
        	  syscall		
	
	#imprimiendo bit cuando es un flotante positvo
	 POSITIVO: li $v0,1			#$a0 se usa para imprimir int
        	  addi $a0,$zero,0
        	  syscall	
	 		
		
		#Mostrar el valor
		li $v0,2
		add.d $f12, $f0, $f4
		syscall
		
