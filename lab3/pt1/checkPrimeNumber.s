.cpu cortex-a53
.fpu neon-fp-armv8

.data
.balign 4

.text
.align 2
.global checkPrimeNumber
.type checkPrimeNumber, %function

checkPrimeNumber:
	push {fp, lr}
	add fp, sp, #4

	mov r4, r0	@ int n
	mov r5, #2	@ int j = 2
	mov r6, #1	@ int flag = 1
	mov r7, #2
	udiv r7, r4, r7	@ n / 2

	loop:
		cmp r5, r7
		bgt end_loop

		@ Calculate mod of n and j
		mov r0, r4
		mov r1, r5
		bl mod
		mov r8, r0	@ n % j

		add r5, #1	@ ++j

		cmp r8, #0
		bne loop
		no_prime:
			mov r6, #0	@ Set flag to 0, n is not prime
		end_loop:
			mov r0, r6	@ Return the flag
	sub sp, fp, #4
	pop {fp, pc}
