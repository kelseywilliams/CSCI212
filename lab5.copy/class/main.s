.cpu cortex-a53
.fpu neon-fp-armv8

.data

ylose:	.asciz	"You lost\n"
ywin:	.asciz	"You win\n"
.balign

board:	.word	0	@ contains the address fo the array with thte guesses
key:	.word	0	@ contains the key generated

.text
.align 2
.global main
.type main, %function

main:
	push {fp, lr}
	add fp, sp, #4

	@ step 0: Allocate memory for the board
	@	maximum # of guesses = 10*4 = 40 bytes
	sub sp, sp, #40

	@ store address into "board"
	ldr r0, =board
	str sp, [r0]	@ board = *(&r0) = sp

	@ Generate key
	@ allocate memory on the stack to store the key, then store 
	@ that address into variable "key"
	sub sp, sp, #4	@allocate 1 memory on the stack for the key
	ldr r0, =key
	str sp, [r0]	@ key = sp
	@ gen_key --> return a 4-byte unsigned int with the values embedde
	@ in the bit stream
	@ reset the random seed
	mov r0, #0
	bl time
	bl srand

	bl gen_key	@ returns into r0 the 4 random numbers packed inside
	ldr r1, =key	@ r1 = address on the stack to store the key
	str r0, [r1]

@@ DEBUG
	bl print_key
	b end_game
@@ DEBUG end

	@ loop from 0 to 9 for up to 10 guesses
	@ r10 = loop counter variable
	mov r10, #0

	main_loop:
		cmp r10, #9
		bge you_lose

		@ r0 = get_userinput()
@		bl get_userinput

		@ store guess into the board
		ldr r1, =board
		ldr r1, [r1]	@ r1 = address of the array
		@ calculate byte offset into the array
		mov r2, r10, LSL #2	@ r2 = r10*4
		str r0, [r1, r2]	@array[r10] = r0 = guess

		@ check_in(userguess, key) --> returns #correct colors/correct locs
		ldr r1, =key
		ldr r1, [r1]

		@ r0 is already the guess
@		bl check_in	@ returns #correct colors/correct locs
		push {r0}	@ store on the stack

		cmp r0, #4	@ if #correct colors/correct locs  
		beq you_win

		@ check_out(userguess, key) --> returns #correct colors
		mov r0, r4
		ldr r1, =key
		ldr r1, [r1]
@		bl check_out	@ r0 = #correct colors

		@ calculate number of correct colors/wrong locations
		ldr r1, [sp]
		@ we had pushed #correct colors/right locs here
		sub r2, r0, r1	@ r2 = #correct colors - #correct colors/correct locs


		@ print update(board, #correct colors/rloc, #correct colors/wloc)
		ldr r0,  = board
		ldr r0, [r0]
		add r3, r10, #1	@ number of guess

@		bl print_update

		add r10, r10, #1

		pop {r0}

		b main_loop
			you_win:
		ldr r0, =ywin
		bl printf
		b end_game

	you_lose:
	ldr r0, =ylose
	bl printf

	end_game:

	sub sp, fp, #4
	pop {fp, pc}
