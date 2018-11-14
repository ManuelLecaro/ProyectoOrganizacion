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
		
		#Mostrar el valor
		li $v0,2
		add.s $f12, $f0, $f4
		syscall
		
