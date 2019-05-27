#	prelim06.asm - a program to find the summation of the elements of a square matrix, 
#                      trace of the matrix, and trace like summation using the other diagonal 
#                      (shaped like: / from right upper corner to left bottom corner) of the matrix.
#

#	Text Segment
	.text
main:
	#s0 will have menu choice s1 will have address for matrix s2 will have size of matrix
	menuL:	la $a0, msg1		#Output message
		li $v0, 4
		syscall
	
		li $v0, 5		#Input the menu choice
		syscall
		move $s0, $v0
		
	m1:	bne $s0, 1, m2		#Ask for size and values
		la $a0, msg2		#get Size
		li $v0, 4
		syscall
		
		li $v0, 5		#Input the size
		syscall
		move $a0, $v0
		move $s2, $v0
		jal createAndAsk
		
		move $s1, $v0		#get the address of the matrix in s1
			
	m2:	bne $s0, 2, m3		#Just ask for size
		la $a0, msg2		#get Size
		li $v0, 4
		syscall
		
		li $v0, 5		#Input the size
		syscall
		move $a0, $v0
		move $s2, $v0
		jal createAndFill
		
		move $s1, $v0		#get the address of the matrix in s1
		
	m3:	bne $s0, 3, m4		#Show value at a given co-ordinate
		la $a0, msg3		#get x co-ordinate
		li $v0, 4
		syscall
		
		li $v0, 5		#Input x co-ordinate
		syscall
		move $t0, $v0
		
		la $a0, msg4		#get y co-ordinate
		li $v0, 4
		syscall
		
		li $v0, 5		#Input y co-ordinate
		syscall
		move $t1, $v0
		
		move $a0, $s1
		move $a1, $s2
		move $a2, $t0
		move $a3, $t1
		jal getValue
		move $t2, $v0
		
		la $a0, msg5		#show value
		li $v0, 4
		syscall
		
		move $a0, $t2
		li $v0, 1
		syscall
		
	m4:	bne $s0, 4, m5		#Display entire matrix
		
		move $a0, $s1
		move $a1, $s2
		jal showMatrix
	
	m5:	bne $s0, 5, m6		#Get Trace
		
		move $a0, $s1
		move $a1, $s2
		jal trace
		
		move $t0, $v0
		la $a0, msg6		#show trace
		li $v0, 4
		syscall
		
		move $a0, $t0
		li $v0, 1
		syscall
		
		
	m6:	bne $s0, 6, m7		#Get other Trace
	
		move $a0, $s1
		move $a1, $s2
		jal oTrace
		
		move $t0, $v0
		la $a0, msg6		#show trace
		li $v0, 4
		syscall
		
		move $a0, $t0
		li $v0, 1
		syscall
	
	m7:	bne $s0, 7, m8		#Sum of matrix row by row
	
		move $a0, $s1
		move $a1, $s2
		jal sumR
		
		move $t0, $v0
		la $a0, msg7		#show sum
		li $v0, 4
		syscall
		
		move $a0, $t0
		li $v0, 1
		syscall
	
	m8:	bne $s0, 8, m9		#Sum of matrix col by col
	
		move $a0, $s1
		move $a1, $s2
		jal sumC
		
		move $t0, $v0
		la $a0, msg7		#show sum
		li $v0, 4
		syscall
		
		move $a0, $t0
		li $v0, 1
		syscall
							
	m9:	beq $s0, 9, mDone
		j menuL
		
mDone:	li $v0, 10		#Exit program
	syscall


#	Methods
createAndAsk:
	addi $sp, $sp, -12	#save only s0, s1 and s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	mul $t0, $a0, $a0	#get the size of array in words
	mul $t1, $t0, 4		#get the size of array in bytes
	move $a0, $t1
	li $v0, 9		#allocate memory
	syscall
	move $s1, $v0		#get address in $s1
	
	move $t2, $0
	move $t1, $s1
	askLoop:		#ask for all values
		bge $t2, $t0, aLEnd
		la $a0, msg9		#get the new number
		li $v0, 4
		syscall
		
		li $v0, 5		#Input the new number
		syscall
		
		sw $v0, 0($t1)		#save the new number
		addi $t1, $t1, 4
		addi $t2, $t2, 1
		j askLoop
	aLEnd:
	
	move $v0, $s1
	
cEnd:	lw $s0, 0($sp)		#load s0, s1 and s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra

createAndFill:
	addi $sp, $sp, -12	#save only s0, s1 and s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	mul $t0, $a0, $a0	#get the size of array in words
	mul $t1, $t0, 4		#get the size of array in bytes
	move $a0, $t1
	li $v0, 9		#allocate memory
	syscall
	move $s1, $v0		#get address in $s1
	
	move $t2, $0
	move $t1, $s1
	askkLoop:		#ask for all values
		bge $t2, $t0, aLlEnd
		addi $t3, $t2, 1
		
		sw $t3, 0($t1)		#save the new number
		addi $t1, $t1, 4
		addi $t2, $t2, 1
		j askkLoop
	aLlEnd:
	
	move $v0, $s1
	
fEnd:	lw $s0, 0($sp)		#load s0, s1 and s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra

getValue:
	addi $sp, $sp, -12	#save only s0, s1 and s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	addi $s0, $a3, -1	#(i - 1) x N x 4 + (j - 1) x 4
	mul $s0, $s0, $a1
	mul $s0, $s0, 4
	
	addi $s1, $a2, -1
	mul $s1, $s1, 4
	
	add $s3, $s0, $s1
	add $s3, $s3, $a0
	
	lw $v0, 0($s3)		#get the value in v0
	
				
vEnd:	lw $s0, 0($sp)		#load s0, s1 and s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra

showMatrix:
	addi $sp, $sp, -12	#save only s0, s1 and s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	li $t0, 1
	li $t1, 1
	move $t2, $a0
	move $t3, $a1
	
	showLoop:		#nested looping
		bgt $t1, $t3, shLEnd
		horLoop:
			bgt $t0, $t3, hrLEnd
			move $a0, $t2
			move $a1, $t3
			move $a2, $t0
			move $a3, $t1
			
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			jal getValue
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			
			move $a0, $v0
			li $v0, 1
			syscall
			
			bge $t0, $t3, noComma
			la $a0, msg8		#print comma
			li $v0, 4
			syscall
			noComma:
			
			addi $t0, $t0, 1
			j horLoop
		hrLEnd:
		la $a0, newL		#print newline
		li $v0, 4
		syscall
		
		addi $t1, $t1, 1
		li $t0, 1
		j showLoop
	shLEnd:
	
sEnd:	lw $s0, 0($sp)		#load s0, s1 and s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra

trace:
	addi $sp, $sp, -12	#save only s0, s1 and s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	li $t0, 1
	li $t1, 0
	move $t2, $a0
	move $t3, $a1
	
	traceLoop:
		bgt $t0, $t3, trLEnd
		move $a0, $t2
		move $a1, $t3
		move $a2, $t0
		move $a3, $t0
			
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal getValue
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		add $t1, $t1, $v0
		
		addi $t0, $t0, 1
		j traceLoop
	trLEnd:
	
	move $v0, $t1
	
tEnd:	lw $s0, 0($sp)		#load s0, s1 and s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra

oTrace:
	addi $sp, $sp, -12	#save only s0, s1 and s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	move $t0, $a1
	li $t4, 1
	li $t1, 0
	move $t2, $a0
	move $t3, $a1
	
	otraceLoop:
		bgt $t4, $t3, otrLEnd
		move $a0, $t2
		move $a1, $t3
		move $a2, $t0
		move $a3, $t4
			
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal getValue
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		add $t1, $t1, $v0
		
		addi $t0, $t0, -1
		addi $t4, $t4, 1
		j otraceLoop
	otrLEnd:
	
	move $v0, $t1
oTEnd:	lw $s0, 0($sp)		#load s0, s1 and s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra

sumR:
	addi $sp, $sp, -12	#save only s0, s1 and s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	li $t0, 1
	li $t1, 1
	move $t2, $a0
	move $t3, $a1
	li $t4, 0
	
	sumLoopr:		#nested looping
		bgt $t1, $t3, suLEndr
		horSumLoopr:
			bgt $t0, $t3, horLEndr
			
			addi $s0, $t1, -1	#(i - 1) x N x 4 + (j - 1) x 4
			mul $s0, $s0, $t3
			mul $s0, $s0, 4
	
			addi $s1, $t0, -1
			mul $s1, $s1, 4
	
			add $s3, $s0, $s1
			add $s3, $s3, $t2
			
			lw $v0, 0($s3)		#get the value in v0
			
			add $t4, $t4, $v0
			
			addi $t0, $t0, 1
			j horSumLoopr
		horLEndr:
		
		addi $t1, $t1, 1
		li $t0, 1
		j sumLoopr
	suLEndr:
	
	move $v0, $t4
	
sREnd:	lw $s0, 0($sp)		#load s0, s1 and s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra

sumC:
	addi $sp, $sp, -12	#save only s0, s1 and s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	li $t0, 1
	li $t1, 1
	move $t2, $a0
	move $t3, $a1
	li $t4, 0
	
	sumLoopc:		#nested looping
		bgt $t1, $t3, suLEndc
		horSumLoopc:
			bgt $t0, $t3, horLEndc
			
			addi $s0, $t0, -1	#(i - 1) x N x 4 + (j - 1) x 4
			mul $s0, $s0, $t3
			mul $s0, $s0, 4
	
			addi $s1, $t1, -1
			mul $s1, $s1, 4
	
			add $s3, $s0, $s1
			add $s3, $s3, $t2
			
			lw $v0, 0($s3)		#get the value in v0
			
			add $t4, $t4, $v0
			
			addi $t0, $t0, 1
			j horSumLoopc
		horLEndc:
		
		addi $t1, $t1, 1
		li $t0, 1
		j sumLoopc
	suLEndc:
	
	move $v0, $t4
	
sCEnd:	lw $s0, 0($sp)		#load s0, s1 and s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra



#	Data Segment
	.data
newL:	.asciiz "\n"
msg1:	.asciiz	"\n\nMenu:\n1- Create and Enter values.\n2- Just Create.\n3- Display Desired.\n4- Display Entire Matrix.\n5- Display Trace.\n6- Trace Other Diagonal.\n7- Sum Row by Row.\n8- Sum Col by Col.\n9- Exit.\nEnter your choice:\n"
msg2:	.asciiz "\nEnter Size of Matrix: "
msg3:	.asciiz "\nEnter X cordinate greater than or equal to 1: "
msg4:	.asciiz "\nEnter Y cordinate greater than or equal to 1: "
msg5:	.asciiz "\nValue at these Co-ordinates: "
msg6:	.asciiz "\nThe trace is: "
msg7:	.asciiz "\nThe sum is: "
msg8:	.asciiz ", "
msg9:	.asciiz "\n Enter number: "
# 	End Of prelim06.asm
