.cpu cortex-a53
.fpu neon-fp-armv8

.data
@any text here

.text
filename:   .asciz  "deck.txt"
waccess:	.asciz  "w"
raccess:    .asciz  "r"
test:       .asciz  "%u\n"
test2:      .asciz  "%d\n"
hand1:      .asciz  "Current Hand:\n\n"
hand2:      .asciz  "New Hand:\n"
spacing:    .asciz  "\n"

.align 2
.global main
.type main, %function

main:

    @save lr
    push {fp, lr}
    add fp, sp, #4

    @code from lect 11 - 
    @ Set the random number seed
    mov r0, #0
    bl time
    bl srand

	@ fpointer = fopen("deck.txt", "w");
    ldr r0, =filename
    ldr r1, =waccess
    bl fopen   @ returns the address to the file in r0

    push {r0}   @ store the filepointer on the stack at fp - 8
    @code from lect 11 -

    @ call shuffle_cards(filepointer)
    bl shuffle_cards

    @ close the file for writing
    ldr r0, [fp, #-8]   @ load in filepointer
    bl fclose

    @ re-open deck.txt for reading
    @ fopen("deck.txt", "r")
    ldr r0, =filename
    ldr r1, =raccess
    bl fopen  @ filepointer is in r0
    str r0, [fp, #-8]

    @deal_cards(filepointer, address)
    sub sp, sp, #4
    mov r1, sp
	ldr r0, [fp, #-8]

    bl deal_cards

    @printf("Current Hand\n")  @player - hand
    ldr r0, = hand1
    bl printf

    ldr r0, [sp]

    @save r0 for later (player hand)
    mov r9, r0

    @ call cards   @ make sure your hand has suits and faces
    bl print_cards

    @printf("n")  @spacing
    ldr r0, = spacing
    bl printf

    ldr r0, [sp]
    @get user input on which cards to change
    bl user_input

    mov r8, r0   @ save for testing

    @printf("n")  @spacing
    ldr r0, = spacing
    bl printf

    @movement for replace_card
    mov r2, r8  @user_input into r2 reg
    @mov r1, r9  @hand
    mov r1, sp  @hand
	ldr r0, [fp, #-8]

	mov r3, #255
    add r3, r3, #255
    add r3, r3, #255
    add r3, r3, #230
    @                      r0           r1               r2              r3
    @                   address    player hand    user_input(bits) last 3 pal id
    @@void replace_card(FILE *fp, unsigned *hand, unsigned indices, unsigned uid);
    bl replace_card

    @printf("New Hand\n")  @player - new hand
    ldr r0, = hand2
    bl printf

    ldr r0, [sp]

    @ call cards  -- again
    bl print_cards

    @load stuff for print_poker - again
    ldr r0, [sp]
    bl print_poker  @@ in progress

    @ close file
    ldr r0, [fp, #-8]
    bl fclose   @ fclose(filepointer)

    @ end program

    sub sp, fp, #4
    pop {fp, pc}

