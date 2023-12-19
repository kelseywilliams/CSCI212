.cpu cortex-a53
.fpu neon-fp-armv8

.data

.balign 4

.text
.align 2
.global cpn
.type cpn, %function

checkPrimeNumber:
	push {fp, lr}
	add fp, sp #4

	mov r4, r0	@ Get the value of n
	mov r5, #1	@ Set flag to 1
	mov r6, #2	@ Set j to 2
	div r7, 


