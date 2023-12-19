.cpu cortex-a53
.fpu neon-fp-armv8
.data
.text
.align 2
.type find_correct_color, %function
.global main

@ int find_correct_color(int guess, int key)
find_correct_color:
	push {fp, lr}
	add fp, sp, #4

	push {r9}
	push {r10}

	mov r4, r0
	mov r5, r1
	mov r6, #0	@ Set number of correct colors
	mov r10, #0	@ Set loop counter
	loop:
		cmp r10, #4
		bge end_program

		ldr r7, 0x000000ff
		add r7, 
		lsr r7, r4, r10
		add r10, r10, #1	@ Increment loop counter
		mov r9, #0	@ Set sub loop counter
		sub_loop:
			cmp r9, #4
			bge loop
			

	end_program:
	mov r0, r6

	pop {r10}
	pop {r9}
	sub sp, fp, #4
	pop {fp, pc}
