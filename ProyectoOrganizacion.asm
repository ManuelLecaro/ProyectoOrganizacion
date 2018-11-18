# Lee el valor ingresado por el usuario y lo guarda en un registro
# Muestra el valor en formato IEEE-754 simple
# Muestra el valor en formato IEEE-754 doble
# Muestra el valor en formato Hexadecimal
# set Register $a0 to contain only bits 12,13,14,15 of $a0

.data
space_u: .space		32
space:.space		64
user: .asciiz     	"Ingrese el número que quiera transformar al formato IEE-754: "
simple:    .asciiz 	"Este es su número en formato IEEE-754 simple: "
double:    .asciiz 	"Este es su número en formato IEEE-754 double: "
nl:         .asciiz     	"\n"
hex:   	   .asciiz     	"Este es su número en hexadecimal: "
hexDigit:   .asciiz     	"0123456789ABCDEF"
obuf:       .space      	100
zerodouble: .double	0.0
zerosimple: .float	0.0
buffer:

.text
.globl  main
main:
    li      $v0,4		#muestra el mensaje para pedir valor al usuario
    la      $a0,user
    syscall
    
   
    li      $v0,6		#guarda el valor de un flotante en el registro $f0
    syscall
    
    
    mfc1   $s0,$f0		#mueve el valor de $so a $f0
	
    add    $s7,$zero,$zero	#$s7 determinada como variable
    
    #simple
    la      $a0,simple		#muestra el mensaje del resultado en formato simple
    li      $a1,32		#carga 32 en a1
    jal     printsmpl		#moviendose a prtbin
    
    #doble
    la      $a0,double		#mostrando el mensaje de resultado en formato doble
    li      $a1,32		
    mfc1.d  $s0,$f0		#mueve el valor de simple a doble 
    jal     printdoub		#moviendose a printdoub
    
    #doble
    la      $a0,double		#mostrando el mensaje de resultado en formato doble
    li      $a1,32		
    jal     printdoub_second		#moviendose a printdoub

    #hexadecimal
    la      $a0,hex		#mostrando el mensaje de resultado en hexadecimal
    li      $a1,16		
    jal     printhex		#moviendose a printhex

    li      $v0,10		#Terminando
    syscall


#imprimiendo en formato simple
#   $a0: donde se guarda el string de salida
#   $a1: numero de bits que se toman para imprimir
printsmpl:
    li      $a2,1                   # base del numero a imprimir
    j       prtany

# imprimiendo en formato doble
#   $a0: donde se guarda el string de salida
#   $a1: numero de bits que se toman para imprimir
printdoub:
    li      $a2,1                   # base de numero a imprimir 1, porque es binario
    j       prtanydouble

# imprimiendo en formato doble
#   $a0: donde se guarda el string de salida
#   $a1: numero de bits que se toman para imprimir
printdoub_second:
    li      $a2,1                   # base de numero a imprimir 1, porque es binario
    j       second_part
    
    
# imprimiendo en formato hexadecimal
#   $a0: donde se guarda el string de salida
#   $a1: numero de bits que se toman para imprimir
printhex:
    li      $a2,4                   # base 4, para imprimir en hexadecimal
    j       prtanyhex

# imprimiendo segun la base del numero
#   a0:  donde se guarda el string
#   a1: cantidad de bits que se muestran
#   a2: base del numero
#   s0: numero a imprimir
# registros temporales
#   t0: digito actual
#   t5: valor restante del digito
#   t6: puntero de salida
#   t7: mascar de bits
prtany:
    li      $t7,1
    sllv    $t7,$t7,$a2             # haciendo mascara de bits con un shift logico segun la base del numero a mostrar
    subu    $t7,$t7,1               # haciendo la mascara para cada digito

    la      $t6,buffer              # seteando el fin del buffer
    subu    $t6,$t6,1               # puntero al char final
    sb      $zero,0($t6)            # guardando string

    move    $t5,$s0                 # guardando el numero
    j	    print_loop		    #moviendose a prtany_loop

prtanyhex:
    
    cvt.w.s $f2,$f0

    li      $v0,4		    #mostrando el valor en $a0
    syscall

    mfc1.d  $a0,$f2
    li      $v0,34
    syscall  
    j       salto
    

prtanydouble:
    li      $t7,1
    sllv    $t7,$t7,$a2             # haciendo mascara de bits con un shift logico segun la base del numero a mostrar
    subu    $t7,$t7,1               # haciendo la mascara para cada digito

    la      $t6,buffer              # seteando el fin del buffer
    subu    $t6,$t6,1               # puntero al char final
    sb      $zero,0($t6)            # guardando string

    #move    $t2,$s0	                   # guardando el numero
    cvt.d.s $f2,$f0		   #guardando un espacio de 64bits en $t2
    mfc1.d  $s3,$f2
    move    $t2,$s4
    
    
prt_loop_double:
    and     $t0,$t2,$t7             # separando el digito
    lb      $t0,hexDigit($t0)       # tomando el valor ASCII

    subu    $t6,$t6,1               # moviendose hacia la derecha un bit
    sb      $t0,0($t6)              # guardando en el buffer

    srlv    $t2,$t2,$a2             # moviendose la cantidad de numeros que en $a2 de bits
    sub     $a1,$a1,$a2             # reduciendo la cantidad de bits que quedan por mostrar
    bgtz    $a1,prt_loop_double   # si quedan valores, continuar
    addi    $s7,$zero,1
    j 	    printing

#referente a la segunda parte de los 32bits con los que se imprime el formato IEEE-754 doble
second_part:
    li      $t7,1
    sllv    $t7,$t7,$a2             # haciendo mascara de bits con un shift logico segun la base del numero a mostrar
    subu    $t7,$t7,1               # haciendo la mascara para cada digito

    la      $t6,buffer              # seteando el fin del buffer
    subu    $t6,$t6,1               # puntero al char final
    sb      $zero,0($t6)            # guardando string

    mfc1.d  $s5,$f2		    #moviendo $f2 a $s5, se guardan solo los primeros 32 bits del valor
    move    $t3,$s5		    #guardando el valor
    
prt_loop_double_rest:
    and     $t0,$t3,$t7             # separando el digito
    lb      $t0,hexDigit($t0)       # tomando el valor ASCII

    subu    $t6,$t6,1               # moviendose hacia la derecha un bit
    sb      $t0,0($t6)              # guardando en el buffer

    srlv    $t3,$t3,$a2             # moviendose la cantidad de numeros que en $a2 de bits
    sub     $a1,$a1,$a2             # reduciendo la cantidad de bits que quedan por mostrar
    bgtz    $a1,prt_loop_double_rest   # si quedan valores, continuar
    move    $s7, $zero
    j 	    printing_second_part
	
   
print_loop:
    and     $t0,$t5,$t7             # separando el digito
    lb      $t0,hexDigit($t0)       # tomando el valor ASCII

    subu    $t6,$t6,1               # moviendose hacia la derecha un bit
    sb      $t0,0($t6)              # guardando en el buffer

    srlv    $t5,$t5,$a2             # moviendose la cantidad de numeros que en $a2 de bits
    sub     $a1,$a1,$a2             # reduciendo la cantidad de bits que quedan por mostrar
    bgtz    $a1,print_loop         # si quedan valores, continuar

printing:
    li      $v0,4		    #mostrando el valor en $a0
    syscall

#caso para mostrar los 32 bits restantes para el formato IEEE-754 doble
printing_second_part:
    move    $a0,$t6                 #moviendo los valores en el buffer a $a0
    syscall
   
    beq     $s7,$zero,salto	    #para evitar el salto de linea cuando se imprimen los 64 bits
    j no_saltes
    
salto:
    la      $a0,nl		    #salto de linea
    syscall
    
no_saltes:
    jr      $ra     		    #retornando