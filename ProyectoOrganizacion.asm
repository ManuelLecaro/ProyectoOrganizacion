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
		
		#extraer el valor del simbolo si es positvo 0 y si es negativo 1 --0x80000000--  sirve como máscara
		c.lt.d $f4, $zero			# CC = $f0 < $zero
		bc1t mostrar_signo     			# Branch if $f0 < $zero
		
		#addi $t2, $zero, 0x80000000
		#and $a0, $t1, $t2
		#srl  $a0, $a0, 31
		
		#mostrando mensajes de resultados
		li $v0, 4
		la $a0, fin
		syscall
		
		#mostrando mensaje de resultado para formato de 32 bits
		li $v0, 4
		la $a0, bits32
		syscall 
		
		#mostrando el bit de signo
		li $v0, 34
		add.d $v0, $zero, 1
		syscall
		
		#Mostrar el valor
		li $v0,2
		add.d $f12, $f0, $f4
		syscall
		
