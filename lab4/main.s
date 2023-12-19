.cpu cortex-a53
.fpu neon-fp-armv8
.data
.text
.align 2
.type main, %function
.global main

@ void split_deck(int p, int a[], int n)
@ int move(int p, int a[])
@ int check_stable(int p, int a[])
@ int left_shift(int p, int a[])
@ int random(int lower, int upper)
@ void print_array(int length, int a[], int counter)
main:
	push {fp, lr}
	add fp, sp, #4

	mov r0, #0
	bl time
	bl srand

	@ allocate mem for sp[45]
	mov r0, #45
	mov r0, r0, lsl #2	@ r0 = r0 * 4
	sub sp, sp, r0		@sp = sp - r0 * 4
	mov r10, #0
	populate_array:
		cmp r10, #45
		bge end_populate_array
		mov r0, #0
		add  r1, sp, r10, LSL #2 @ r1 = sp + r10 * 4
		str r0, [r1]
		add r10, r10, #1
		b populate_array
	end_populate_array:
	mov r0, #1
	mov r1, #45
	bl random		@ int p = random(1, 45)
	mov r4, r0
	@ --- call split_deck(int, int[], int) ---
	@ r0 = p
	mov r1, sp
	mov r2, #45
	bl split_deck	@ split_deck(p, sp, n)

	mov r10, #0	@ set counter
	play:
		@ --- call print_array(int, int[], int)
		mov r0, #45
		mov r1, sp
		mov r2, r10
		bl print_array

		@ --- call check_stable(int, int[])
		mov r0, r4
		mov r1, sp
		bl check_stable

		@ if check_stable is true, end program; else move
		cmp r0, #1
		beq end_program

		@ --- call move(int, int[])
		mov r0, r4
		mov r1, sp
		bl move
		mov r4, r0

		add r10, r10, #1	@ increment counter

		mov r0, #45
		mov r1, sp
		mov r2, r10

		b play
	end_program:
		sub sp, fp, #4
		pop {fp, pc}
