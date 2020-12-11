.data
frameBuffer: .space 0x80000 #512wideX256highpixels
m: .word 40
n: .word 177
c1r: .word 0xff
c1g: .word 0x00
c1b: .word 0x00
c2r: .word 0xff
c2g: .word 0x00
c2b: .word 0xff
c3r: .word 0x00
c3g: .word 0x00
c3b: .word 0xff
.text
#t0 contains base address of array
la $t0, frameBuffer
la $t7, frameBuffer

#s3 contains the color 1
la $s3, c1r
lw $s3, 0($s3)
la $t2, c1g
lw $t2, 0($t2)
la $t3, c1b
lw $t3, 0($t3)
sll $s3, $s3, 16
sll $t2, $t2, 8
add $s3, $s3, $t2
add $s3, $s3, $t3

#t2 contains the color 2
la $t2, c2r
lw $t2, 0($t2)
la $t3, c2g
lw $t3, 0($t3)
la $t4, c2b
lw $t4, 0($t4)
sll $t2, $t2, 16
sll $t3, $t3, 8
add $t2, $t2, $t3
add $t2, $t2, $t4

#t3 contains the color 3
la $t3, c3r
lw $t3, 0($t3)
la $t4, c3g
lw $t4, 0($t4)
la $t5, c3b
lw $t5, 0($t5)
sll $t3, $t3, 16
sll $t4, $t4, 8
add $t3, $t3, $t4
add $t3, $t3, $t5

#t4 contains memory address of end of array + 4
li $t4, 0x80000
add $t4, $t0, $t4

#t5 contains n
la $t5, n
lw $t5, 0($t5)
andi $t6, $t5, 1
beq $t6, $zero, Even
addi $t5, $t5, 1

#t1 contains m
Even: la $t1, m
lw $t1, 0($t1)

sll $s0, $t1, 1
add $s0, $s0, $t5
li $s1, 256
slt $s2, $s1, $s0
bne $s2, $zero, End

#color the whole display with color 1
Loop: sw $s3, 0($t0)
addi $t0, $t0, 4
bne $t0, $t4, Loop


#s0 contains offset of upper left corner of square
#t4 contains offset of row below lower left corner of square
#t6 contains n/2
li $s0, 127
srl $t6, $t5, 1
sub $s0, $s0, $t6
sub $s0, $s0, $t1
sll $s0, $s0, 9
li $s1, 256
sub $s1, $s1, $t6
add $s0, $s0, $s1
sll $s0, $s0, 2
sll $t4, $t1, 1
add $t4, $t4, $t5
sll $t4, $t4, 11
add $t4, $t4, $s0

add $t0, $t7, $s0
NextLine1: sll $s2, $t5, 2
add $s2, $s2, $t0
Line1: sw $t2, 0($t0)
addi $t0, $t0, 4
bne $t0, $s2, Line1
addi $s0, $s0, 0x800
add $t0, $t7, $s0
bne $s0, $t4, NextLine1

li $s0, 127
srl $t6, $t5, 1
sub $s0, $s0, $t6
sll $s0, $s0, 9
li $s1, 256
sub $s1, $s1, $t6
sub $s1, $s1, $t1
add $s0, $s0, $s1
sll $s0, $s0, 2
sll $t4, $t5, 11
add $t4, $t4, $s0

add $t0, $t7, $s0
NextLine2: sll $s2, $t1, 1
add $s2, $s2, $t5
sll $s2, $s2, 2
add $s2, $s2, $t0
Line2: sw $t2, 0($t0)
addi $t0, $t0, 4
bne $t0, $s2, Line2
addi $s0, $s0, 0x800
add $t0, $t7, $s0
bne $s0, $t4, NextLine2

li $s0, 127
srl $t6, $t5, 1
sub $s0, $s0, $t6
sll $s0, $s0, 9
li $s1, 256
sub $s1, $s1, $t6
add $s0, $s0, $s1
sll $s0, $s0, 2
sll $t4, $t5, 11
add $t4, $t4, $s0

add $t0, $t7, $s0
NextLine3: sll $s2, $t5, 2
add $s2, $s2, $t0
Line3: sw $t3, 0($t0)
addi $t0, $t0, 4
bne $t0, $s2, Line3
addi $s0, $s0, 0x800
add $t0, $t7, $s0
bne $s0, $t4, NextLine3

End: li $v0, 10
syscall
