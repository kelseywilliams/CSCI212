  .cpu cortex-a53
.fpu neon-fp-armv8
.data
guess:	.asciz	"Guess %d:"
str:	.asciz	"%s"
digit:	.asciz	"%x"
char:	.asciz	"%c"
nl:	.asciz	"\n"

.equ B, 0x42
.equ G, 0x47
.equ O, 0x4f
.equ P, 0x50
.equ R, 0x52
.equ Y, 0x59

.text
.align 2
.type get_guess, %function
.global get_guess

@ void get_guess(int round, int guess)
get_guess:
	push {fp, lr}
	add fp, sp, #4

	push {r10}

	mov r3, r0	@ store round number
	mov r4, r1	@ store guess array
	ldr r0, =guess
	mov r1, r3
	bl printf	@ prompt user for guess

	ldr r0, =str
	mov r1, r4
	bl scanf

	@ Store numerical guess array in r7
	mov r7, #0
	mov r5, #0
	ldr r6, [r4]
	digest:
		cmp r5, #4
		bge end_program

		@ Set mask over r6 and extract ascii character in the right most byte
		and r1, r6, #0x000000ff

		@ Shift r7 over by three places in order to have it's rightmost bits overwritten
		mov r7, r7, LSL #3

		@ Begin searching for the ascii digit and sets its numerical equivalent for
		@ internal calculating
		cmp r1, #B
		beq set_b
		cmp r1, #G
		beq set_g
		cmp r1, #O
		beq set_o
		cmp r1, #P
		beq set_p
		cmp r1, #R
		beq set_r
		cmp r1, #Y
		beq set_y
		set_b:
			orr r7, r7, #0
			b finish_set
		set_g:
			orr r7, r7, #1
			b finish_set
		set_o:
			orr r7, r7, #2
			b finish_set
		set_p:
			orr r7, r7, #3
			b finish_set
		set_r:
			orr r7, r7, #4
			b finish_set
		set_y:
			orr r7, r7, #5
			b finish_set

		finish_set:
		lsr r6, r6, #8
		ldr r0, =char
		bl printf
		add r5, r5, #1
		b digest
	end_program:
	ldr r0, =nl
	bl printf
	ldr r0, =digit
	mov r1, r7
	bl printf
	ldr r0, =nl
	bl printf

	str r7, [r4]

	pop {r10}

	sub sp, fp, #4
	pop {fp, pc}

