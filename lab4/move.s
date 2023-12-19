.cpu cortex-a53
.fpu neon-fp-armv8

.text
.align 2
.type move, %function
.global move

@ int move(int p, int a[])
move:
	push {fp, lr}
	add fp, sp, #4

	mov r8, #0	@ total = 0
	mov r7, #0	@ i = 0
	take_card:
		cmp r7, r0
		bge end_program

		add r2, r1, r7, LSL #2
		ldr r2, [r2]
		cmp r2, #0		@ if a[i] != 0, else jmp to is_zero
		beq is_zero
		add r8, r8, #1		@ total++

		sub r2, r2, #1
		add r3, r1, r7, LSL #2
		str r2, [r3]		@ a[i]--

		cmp r2, #0
		beq is_zero		@ if a[i] == 0 jmp to is_zero, else inc i

		add r7, r7, #1
		b take_card
		is_zero:
			bl left_shift
			b take_card
	end_program:
		add r2, r1, r0, LSL #2
		str r8, [r2]			@ a[p] == total

		add r0, r0, #1			@ p++

		sub sp, fp, #4
		pop {fp, pc}
