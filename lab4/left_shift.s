.cpu cortex-a53
.fpu neon-fp-armv8
.data
.text
.align 2
.type left_shift, %function
.global left_shift

@ int left_shift(int p, int a[])
left_shift:
	push {fp, lr}
	add fp, sp, #4

	mov r5, r0	@ r5 = p
	mov r6, r1	@ r6 = a[]

	mov r9, #0	@ r9 = i
	zero_search:
		cmp r9, r5
		bge end_program

		add r0, r5, #1          @ r0 = p + 1
		add r1, r9, #1          @ r1 = j = i + 1

		add r2, r6, r9, LSL #2
		ldr r2, [r2]		@ r2 = a[i]
		cmp r2, #0		@ if a[i] == 0, else continue
		bne continue
		shift:
			cmp r1, r5
			bge end_shift		@ if j < p, else end_shift

			add r2, r6, r1, LSL #2
			ldr r2, [r2]		@ r2  = a[j]

			sub r0, r1, #1		@ r0 = j - 1
			add r3, r6, r0, LSL #2
			str r2, [r3]		@ a[j -1] = a[j]
			add r1, r1, #1		@ j++
			b shift

		end_shift:
			sub r5, r5, #1
			add r2, r6, r1, LSL #2
			mov r3, #0
			str r3, [r2]		@ a[--p] = 0

		continue:
			add r9, r9, #1		@ i++
			b zero_search
	end_program:
		mov r0, r5				@ return p
		mov r1, r6				@ leave a[] in r6 for use in parent func, move()

		sub sp, fp, #4
		pop {fp, pc}
