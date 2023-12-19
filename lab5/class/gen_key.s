.cpu cortex-a53
.fpu neon-fp-armv8

.data

debug:	.asciz	"%d\n"

.text
.align 2
.global gen_key
.type gen_key, %function

gen_key:
	push {fp, lr}
	add fp, sp, #4

	@ generate a number 0 to 5

	@ save register values
	push {r4}
	push {r10}

	mov r4, #0	@ use r4 to store the bitstream containng the numbers
	mov r10, #0	@ counter variable

	gen_key_loop:
		cmp r10, #4
		bge end_gen_key_loop

		bl rand @ r0 = large number
		mov r1, #6	@ mod(r0, 6) -> 0 to 5
		bl mod

		@ stick the number into r4
		mov r4, r4, LSL #3

		orr r4, r4, r0	@ stick the random number into r4

		add r10, r10, #1
		b gen_key_loop

	end_gen_key_loop:

@@ DEBUG begin
	ldr r0, =debug
	mov r1, r4
	bl printf
@@ DEBGUG end

	mov r0, r4	@ return r4 to the main function
	@ restore my registers
	pop {r10}
	pop {r4}
	sub sp, fp, #4
	pop {fp, pc}
