.cpu cortex-a53
.fpu neon-fp-armv8
.data
.text
.align 2
.type check_stable, %function
.global check_stable

@ int check_stable(int p, int a[])
check_stable:
	push {fp, lr}
	add fp, sp, #4

	cmp r0, #9
	bne unstable

	mov r9, #0	@ i = 0
	verify:
		add r8, r9, #1		@ j = i + 1
		cmp r9, #8		@ while(i < 8)
		bge stable		@ if i >= 8, jmp to stable
		add r2, r1, r9, LSL #2
		ldr r2, [r2]		@ r2 = a[i]
		add r3, r1, r8, LSL #2
		ldr r3, [r3]		@ r3 = a[j]
		sub r3, r3, #1		@ r3 = r3 + 1
		cmp r2, r3		@ if r2 == r3, jmp to unstable
		bne unstable

		add r9, r9, #1
		b verify
	stable:
		mov r0, #1
		b end_program
	unstable:
		mov r0, #0
		b end_program

	end_program:
		sub sp, fp, #4
		pop {fp, pc}
