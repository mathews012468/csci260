.data
a: .word 12
b: .word 25
arr: .word 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

.text
main: 
lw $t0, a #t0 <- a
lw $t1, b #t1 <- b

#checks if a>=0
slt $t2, $t0, $zero
bne $t2, $zero, Exit

#checks if b>=a
slt $t2, $t1, $t0
bne $t2, $zero, Exit

#checks if 99>=b
li $t5, 99
slt $t2, $t5, $t1
bne $t2, $zero, Exit

addi $t1, $t1, 1
la $t6, arr #address of arr
li $t2, 10
div $t0, $t2
mfhi $t3 #t3 <- a%10
mflo $t4 #t4 <- a/10
add $t8, $zero, $zero

Loop: 
#display left and right digit for each number in the interval
#to display left:
#pass in t4 as an argument (a0)
#pass in left display address (a1)
#pass in address of arr

#push t0, t1, t3, t4, t6, t8
addi $sp, $sp, -4
sw $t0, 0($sp)
addi $sp, $sp, -4 
sw $t1, 0($sp)
addi $sp, $sp, -4
sw $t3, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
addi $sp, $sp, -4
sw $t6, 0($sp)
addi $sp, $sp, -4
sw $t8, 0($sp)

add $a0, $t4, $zero
addi $a1, $zero, 0xFFFF0011
add $a2, $t6, $zero
bne $t8, $zero, maybeOnes
bne $t4, $zero, ones
maybeOnes: addi $a1, $a1, -1
add $a0, $t3, $zero
ones: jal display

#pop variables back
lw $t8, 0($sp)
addi $sp, $sp, 4
lw $t6, 0($sp)
addi $sp, $sp, 4
lw $t4, 0($sp)
addi $sp, $sp, 4
lw $t3, 0($sp)
addi $sp, $sp, 4
lw $t1, 0($sp)
addi $sp, $sp, 4
lw $t0, 0($sp)
addi $sp, $sp, 4

xori $t8, $t8, 1
bne $t8, $zero, Loop
addi $t3, $t3, 1
bne $t3, 10, notNextTen
add $t3, $zero, $zero
addi $t4, $t4, 1

notNextTen: 
addi $t7, $zero, 700000
Delay: 
addi $t7, $t7, -1
bne $t7, $zero, Delay
addi $t0, $t0, 1
bne $t0, $t1, Loop

Exit:
li $v0, 10
syscall

display:
sll $t0, $a0, 2
add $t0, $t0, $a2 #t0 <- address of correct number display
lw $t0, 0($t0) #t0 <- correct number display
sb $t0, 0($a1)
jr $ra