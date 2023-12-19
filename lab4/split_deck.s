.cpu cortex-a53
.fpu neon-fp-armv8
.data
.text
.align 2
.type split_deck, %function
.global split_deck

@void split_deck(int p, int a[], int n)
split_deck:
	push {fp, lr}
	add fp, sp, #4

	mov r4, r0	@ r4 = p
	mov r7, r1	@ r7 = a[]
	mov r8, r2	@ r8 = n

	mov r10, #0
	create_pile:
		sub r3, r4, #1
		cmp r10, r3	@ (i < p - 1)
		bge end_create_pile

		sub r9, r8, r4	@ n - p
		add r9, r9, r10 @ (n - p) + r10
		add r9, r9, #1	@ (n - p + r10) + 1

		mov r1, r9
		mov r0, #1
		bl random	@ r0 = random(1, (n - p + r10) + 1)

		sub r8, r8, r0	@ n = n - x

		add r1, r7, r10, LSL #2	@ r1 = a[0 + r10*4]

		str r0, [r1]	@ a[r10] = r0

		add r10, r10, #1

		b create_pile
	end_create_pile:

	add r1, r7, r10, LSL #2

	str r8, [r1]
	end_program:
	sub sp, fp, #4
	pop {fp, pc}
