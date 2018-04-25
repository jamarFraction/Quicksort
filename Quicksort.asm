#Jamar Fraction
#CPTS260
#HW5, question 3

.text
la $a0, myArry
li $a1, 0
li $a2, 6

#call the QUICKSORT algo
jal QUICKSORT

#array is now sorted, print to console using function
jal printArray

#end the program
li $v0, 10
syscall

FAILEDQUICKSORTINITIALCONDITION:
jr $ra

QUICKSORT:
bge $a1, $a2, FAILEDQUICKSORTINITIALCONDITION

#store the current return address
addi $sp, $sp, -4
sw $ra, ($sp)

#Calling PARTITION function
jal PARTITION

#assign the returned val from PARTITION to 'p'
move $s0, $v0

#store 'hi' so its not lost
addi $sp, $sp, -4
sw $a2, ($sp)

#load 'p' to 3rd argument
move $a2, $s0

#calling QUICKSORT(A, lo, p)
jal QUICKSORT

#temp-store p
move $a2, $t0

#recover hi to 3rd argument
lw $a2, ($sp)
addi $sp, $sp, 4

#store lo and 'p' to the stack
addi $sp, $sp, -8
sw $a1, ($sp)
sw $t0, 4($sp)

#store ('p' + 1) to second argument
addi $a1, $t0, 1

#calling QUICKSORT(A, ['p' + 1], hi)
jal QUICKSORT

#recover lo and 'p'
lw $s0, 4($sp)
lw $a1, ($sp)
addi $sp, $sp, 8

#recover return address
lw $ra, ($sp)
addi $sp, $sp, 4

#EXIT
jr $ra


PARTITION:
#set pivot
move $t0, $a1
sll $t3, $t0, 2
add $t3, $t3, $a0
lw $t2, ($t3)
addi $t0, $a1, -1
addi $t1, $a2, 1

MAINLOOP:
LOOP1:
addi $t0, $t0, 1
sll $t3, $t0, 2
add $t3, $t3, $a0
lw $t3, ($t3)
bge $t3, $t2, LOOP2
j LOOP1

LOOP2:
addi $t1, $t1, -1
sll $t4, $t1, 2
add $t4, $a0, $t4
lw $t4, ($t4)
ble $t4, $t2, EXITLOOP2
j LOOP2

EXITLOOP2:
bge $t0, $t1, RETURN
sll $t3, $t0, 2
sll $t4, $t1, 2
add $t3, $a0, $t3	#address of A[i]
add $t4, $a0, $t4	#address of A[j]
lw $t5, ($t3)
lw $t6, ($t4)
sw $t5, ($t4)		#place A[j] into A[i]
sw $t6, ($t3)		#place A[i] into A[j]
j MAINLOOP

RETURN:
move $v0, $t1
jr $ra

#//////////////////////
printArray:
move $t0, $a0
li $t2, 0

LOOP3:
lw $t1, ($t0)
move $a0, $t1

li $v0, 1
syscall

la $a0, space
li $v0, 4
syscall

addi $t0, $t0, 4
addi $t2, $t2, 1
bne $t2, 7, LOOP3
jr $ra 
#//////////////////////

.data
myArry: .word 10,2,17,9,6,4,8

space: .ascii " "
