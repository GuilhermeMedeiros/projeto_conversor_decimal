.data
prompt_menu: .asciiz "\n Escolha a conversao:\n1. Decimal para Binario\n2. Decimal para Hexadecimal\n3. Decimal para Octal\n4. Finalizar programa\nDigite sua escolha: "
prompt_num:  .asciiz "Digite um numero decimal: "
newline:     .asciiz "\n"
buffer_bin:  .space 33
buffer_hex:  .space 12
buffer_oct:  .space 12

.text
.globl main
main:
menu:
    li $v0, 4
    la $a0, prompt_menu
    syscall


    li $v0, 5
    syscall
    move $t3, $v0

    
    beq $t3, 4, finalizar_programa

    
    li $v0, 4
    la $a0, prompt_num
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    
    beq $t3, 1, decimal_para_binario
    beq $t3, 2, decimal_para_hexadecimal
    beq $t3, 3, decimal_para_octal      
    
    j menu          
    
#decimal para binario
decimal_para_binario:
    la $a0, buffer_bin
    li $t1, 32
    li $t4, 0

loop_binario:
    beqz $t1, fim_binario
    srl $t2, $t0, 31
    andi $t2, $t2, 1
    bnez $t2, encontrado_um
    beqz $t4, pular_zero
    
encontrado_um:
    li $t4, 1
    addi $t2, $t2, 48
    sb $t2, 0($a0)
    addi $a0, $a0, 1

pular_zero:
    sll $t0, $t0, 1
    subi $t1, $t1, 1
    j loop_binario

fim_binario:
    beq $t4, 1, fim_binario_final
    addi $a0, $a0, 1
    li $t2, 48
    sb $t2, -1($a0)

fim_binario_final:
    sb $zero, 0($a0)
    la $a0, buffer_bin
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    j menu

    
#decimal para hexadecimal
decimal_para_hexadecimal:
    la $a0, buffer_hex
    li $t1, 0

loop_hexadecimal:
    beqz $t0, fim_hexadecimal
    andi $t2, $t0, 15
    blt $t2, 10, digito_hexadecimal
    addi $t2, $t2, 55
    j armazena_hexadecimal

digito_hexadecimal:
    addi $t2, $t2, 48

armazena_hexadecimal:
    sb $t2, 0($a0)
    addi $a0, $a0, 1
    addi $t1, $t1, 1
    srl $t0, $t0, 4
    j loop_hexadecimal

fim_hexadecimal:
    sb $zero, 0($a0)
    sub $a0, $a0, $t1
    add $a1, $a0, $t1
    addi $a1, $a1, -1

inverter_hexadecimal:
    bge $a0, $a1, fim_inversao_hexadecimal
    lb $t2, 0($a0)
    lb $t3, 0($a1)
    sb $t3, 0($a0)
    sb $t2, 0($a1)
    addi $a0, $a0, 1
    addi $a1, $a1, -1
    j inverter_hexadecimal

fim_inversao_hexadecimal:
    la $a0, buffer_hex
    li $v0, 4
    syscall

    j menu                     
#decimal para octal
decimal_para_octal:
    la $a0, buffer_oct
    li $t1, 0

loop_octal:
    beqz $t0, fim_octal
    andi $t2, $t0, 7
    addi $t2, $t2, 48
    sb $t2, 0($a0)
    addi $a0, $a0, 1
    addi $t1, $t1, 1
    srl $t0, $t0, 3
    j loop_octal

fim_octal:
    sb $zero, 0($a0)
    sub $a0, $a0, $t1
    add $a1, $a0, $t1
    addi $a1, $a1, -1

inverter_octal:
    bge $a0, $a1, fim_inversao_octal
    lb $t2, 0($a0)
    lb $t3, 0($a1)
    sb $t3, 0($a0)
    sb $t2, 0($a1)
    addi $a0, $a0, 1
    addi $a1, $a1, -1
    j inverter_octal

fim_inversao_octal:
    la $a0, buffer_oct
    li $v0, 4
    syscall
    j menu

    finalizar_programa:
    li $v0, 10
    syscall



