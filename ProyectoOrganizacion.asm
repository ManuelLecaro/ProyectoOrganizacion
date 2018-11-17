# Read integer A from user and store it into a register
# Display the integer in binary
# Display the integer in Hex
# set Register $a0 to contain only bits 12,13,14,15 of $a0
# Display the integer in binary contained in $a0
# Display the integer in hex contained in $a0

    .data
userInput:  .asciiz     "Please enter your integer: "
binaryInput:    .asciiz "Here is the input in binary: "
doubleInput:   .asciiz "Here is the output in IEEE-757 double: "
nl:         .asciiz     "\n"
hexInput:   .asciiz     "Here is the input in hexadecimal: "
binaryOutput:   .asciiz "Here is the output in IEEE-754 simple: "
doubleOutput:   .asciiz "Here is the output in IEEE-757 double: "
hexOutput:  .asciiz     "Here is the output in hexadecimal: "
hexDigit:   .asciiz     "0123456789ABCDEF"
obuf:       .space      100
zerodouble: .double	0.0
obufe:

    .text
    .globl  main
main:
    # ask end-user to submit an integer value
    li      $v0,4
    la      $a0,userInput
    syscall

    # read user-input
    li      $v0,6
    syscall
    mfc1    $s0,$f0
    
    #move user-input to double
    lwc1  $f6, zerodouble
    add.d $f2, $f0, $f6

    # output original in binary
    la      $a0,binaryInput
    li      $a1,32
    jal     prtbin
    
    # output original in double
    la      $a0,doubleInput
    li      $a1,64
    mfc1.d  $s0,$f0
    jal     prtdoub

    # output original in hex
    la      $a0,hexInput
    li      $a1,32
    jal     prthex

    # isolate bits 12,13,14,15
    srl     $s0,$s0,12
    andi    $s0,$s0,0x0F

    # output isolated in binary
    la      $a0,binaryOutput
    li      $a1,4
    jal     prtbin
    
    # output isolated in double
    la      $a0,doubleOutput
    li      $a1,4
    jal     prtdoub

    # output isolated in hex
    la      $a0,hexOutput
    li      $a1,4
    jal     prthex

    # exit the program
    li      $v0,10
    syscall

# prtbin -- print in binary
#
# arguments:
#   a0 -- output string
#   a1 -- number of bits to output
prtbin:
    li      $a2,1                   # bit width of number base digit
    j       prtany

# prtbin -- print in binary
#
# arguments:
#   a0 -- output string
#   a1 -- number of bits to output
prtdoub:
    li      $a2,1                   # bit width of number base digit
    j       prtanydouble
    
# prthex -- print in binary
#
# arguments:
#   a0 -- output string
#   a1 -- number of bits to output
prthex:
    li      $a2,4                   # bit width of number base digit
    j       prtany

# prtany -- print in given number base
#
# arguments:
#   a0 -- output string
#   a1 -- number of bits to output
#   a2 -- bit width of number base digit
#   s0 -- number to print
#
# registers:
#   t0 -- current digit value
#   t5 -- current remaining number value
#   t6 -- output pointer
#   t7 -- mask for digit
prtany:
    li      $t7,1
    sllv    $t7,$t7,$a2             # get mask + 1
    subu    $t7,$t7,1               # get mask for digit

    la      $t6,obufe               # point one past end of buffer
    subu    $t6,$t6,1               # point to last char in buffer
    sb      $zero,0($t6)            # store string EOS

    move    $t5,$s0                 # get number
    j	    prtany_loop

prtanydouble:
    li      $t7,1
    sllv    $t7,$t7,$a2             # get mask + 1
    subu    $t7,$t7,1               # get mask for digit

    la      $t6,obufe               # point one past end of buffer
    subu    $t6,$t6,1               # point to last char in buffer
    sb      $zero,0($t6)            # store string EOS

    mov.d    $f8,$f2                 # get number
    
prtany_loop_double:
    and     $t0,$t5,$t7             # isolate digit
    lb      $t2,hexDigit($t0)       # get ascii digit

    subu    $t6,$t6,1               # move output pointer one left
    sb      $t0,0($t6)              # store into output buffer

    srlv    $t5,$t5,$a2             # slide next number digit into lower bits
    sub     $a1,$a1,$a2             # bump down remaining bit count
    bgtz    $a1,prtany_loop         # more to do? if yes, loop
    j 	    printing

prtany_loop:
    and     $t0,$t5,$t7             # isolate digit
    lb      $t0,hexDigit($t0)       # get ascii digit

    subu    $t6,$t6,1               # move output pointer one left
    sb      $t0,0($t6)              # store into output buffer

    srlv    $t5,$t5,$a2             # slide next number digit into lower bits
    sub     $a1,$a1,$a2             # bump down remaining bit count
    bgtz    $a1,prtany_loop         # more to do? if yes, loop

printing:
    # output string
    li      $v0,4
    syscall

    # output the number
    move    $a0,$t6                 # point to ascii digit string start
    syscall

    # output newline
    la      $a0,nl
    syscall

    jr      $ra     