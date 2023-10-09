.cpu	cortex-a53
.fpu	neon-fp-armv8

.data

.text
.align 2
.global gcd
.type gcd, %function

gcd:
	push {fp, lr}
	add fp, sp, #4

	loop:
		@ Get the remainder

		@ Perform modulo operation by getting the quotient and multiplying
		@ by b and subtracting this value from a
		udiv r2, r0, r1
		mul r2, r2, r1
		sub r2, r0, r2
		mov r0, r1		@ a = b
		cmp r2, #0		@ if r == 0, exit
		beq exit
		mov r1, r2		@ else b = r

		b loop

	exit:

	mov r0, r1

	sub sp, fp, #4
	pop {fp, pc}
