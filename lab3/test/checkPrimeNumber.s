.cpu cortex-a53
.fpu neon-fp-armv8

.data
o:	.asciz "%d\n"
.balign 4

.text
.align 2
.global checkPrimeNumber
.type checkPrimeNumber, %function

checkPrimeNumber:
	push {fp, lr}
	add fp, sp, #4

	mov r4, r0	@ Get the value of n
	mov r5, #1	@ Set flag to 1
	mov r6, #2	@ Set j to 2
	udiv r7, r4, r6 @ Set n/2

	ldr r0, =o
	mov r1, r7
	bl printf
loop:
	ldr r0, =o
	mov r1, r6
	bl printf

	ldr r0, =o
	mov r1, r7
	bl printf

	cmp r6, r7
	ble exit

	@ define modulo of n%j to r8
	udiv r8, r4, r6
	mul r8, r8, r6
	sub r8, r4, r8

	add r6, r6, #1

	cmp r8, #0
	beq set_flag
	b loop
set_flag:
	mov r5, #0
	b exit
exit:
	mov r0, r5

