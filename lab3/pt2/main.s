.cpu	cortex-a53
.fpu	neon-fp-armv8

.data
prompt1:	.asciz "Enter two positive integers: "
input:		.asciz "%d %d"
output_pt1:	.asciz "Prime numbers between %d and %d are: \n"
output_pt2:	.asciz "%d "
ln:		.asciz "\n"

.balign 4

n:	.word 0
n2:	.word 0

.text
.align 2
.global main
.type main, %function

main:
	push {fp, lr}
	add fp, sp, #4

	@ print prompt for positive integers
	ldr r0, =prompt1
	bl printf

	@ collect user input in vars n and n2
	ldr r0, =input
	ldr r1, =n
	ldr r2, =n2
	bl scanf

	@ print beginning of output and reiterate n and n2
	ldr r0, =output_pt1
	ldr r1, =n
	ldr r1, [r1]
	ldr r2, =n2
	ldr r2, [r2]
	bl printf

	@ i = r9
	ldr r9, =n
	ldr r9, [r9]
	add r9, #1

	@ n2 = r10
	ldr r10, =n2
	ldr r10, [r10]

	loop:
		cmp r9, r10
		bgt exit

		mov r0, r9
		bl checkPrimeNumber

		mov r1, r9
		add r9, r9, #1

		cmp r0, #1
		bne loop
		if_prime:
			ldr r0, =output_pt2
			bl printf
			b loop
		exit:
			ldr r0, =ln
			bl printf
mov r0, #0

pop {fp, pc}
sub sp, fp, #4
