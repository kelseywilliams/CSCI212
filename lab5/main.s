.cpu cortex-a53
.fpu neon-fp-armv8
.data
.guess:	.asciz	"Guess %d:"
.dec:	.asciz	"%d"
.str:	.asciz	"%s"
.nl:	.asciz	"\m"
.win:	.asciz	"You won!\n"
.lose:	.asciz	"You lost!\n"
.print_game:	.asciz	"%d correct color(s) in the correct location\n%d correct color(s) in the wrong location\n"

.balign

board:	.word	0	@ contains the address for the array with the guesses
key:	.word	0	@ contains the key generated

.text
.align 2
.type main, %function
.global main

@ int generate_key()
@ void get_guess(int round, int guess)
@ int find_correct_color(int guess, int key)
@ int find_correct(int guess, int key, int* win)
@ void print_game(int white, int black)
@ int rand_gen(int lower, int upper)

main:
	push {fp, lr}
	add fp, sp, #4

	mov r0, #0
	bl time
	bl srand

	@ Allocate memory for the board
	@ maximum # of guesses = 10*4 = 40 bytes
	@sub sp, sp, #40

	@ store address into board
	@ldr r0, =board
	@str sp, [r0]	@ board = *(&r0) = sp

	@ Generate key
	ldr r0, =key
	bl generate_key	@ returns into r0 the 4 random numbers packed inside

	mov r9, #0		@ set win flag
	mov r10, #0		@ set counter

	@@ DEBUG
	ldr r0, =key
	ldr r0, [r0]
	bl print_key
	@@ DEBUG end
	turn:
		cmp r10, #10
		bge lose

		cmp r9, #1
		beq win

		mov r0, r10
		ldr r1, =board
		bl get_guess

		@ ----- call find_correct_color(int[], int[]) -----
		mov r0, sp
@		bl find_correct_color
		mov r7, r0
		@ ----- call find_correct(int[], int[])
		mov r0, sp
@		bl find_correct
		mov r8, r0

		@ ----- call print_game(int, int) -----
		mov r0, r7
		mov r1, r8
@		bl print_game

		add r10, r10, #1
		b turn
	win:
		ldr r0, =win
		bl printf
		b end_program
	lose:
		ldr r0, =lose
		bl printf
		b end_program

	end_program:
	sub sp, fp, #4
	pop {fp, pc}

