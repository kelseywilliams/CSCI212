.cpu	cortex-a53
.fpu	neon-fp-armv8

.data

.balign 4

n: 	.word 0

.text
.align 2
.global fib
.type fib, %function

fib:
	push {fp, lr}
	add fp, sp, #4

	mov r1, #1		@ current
	mov r2, #0		@ previous
	mov r4, #1		@ i
	loop:
		@ Check to see if i equals n
		cmp r4, r0
		@ If so exit the function
		beq exit
		@ Else increment I
		add r4, r4, #1
		@ Place the sum of current and previous into r3
		add r3, r1, r2
		@ Set previous equal to current
		mov r2, r1
		@ Set current equal to r3
		mov r1, r3
		b loop
	exit:
		pop {fp, pc}
		sub sp, fp, #4
