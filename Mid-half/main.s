.cpu cortex-a53
.fpu neon-fp-armv8

.data
@any text here

.text
filename:   .asciz  "deck.txt"
waccess:    .asciz  "w"
raccess:    .asciz  "r"


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
    
    @ call shuffle_cards(filepointer) -something like fjd for cards
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

    ldr r0, [sp]
    
    @save r0 for later
    mov r9, r0
    
    @ call cards   @@ big thanks to my group mates for reminding me that I needed to put suits and Faces
    bl print_cards
    
    @bl print_poker  @@ to be called in print_cards when I have it
    
    bl user_input 
    
    @movemnt for replace_card
    mov r2, r0  @user_input into r2 reg 
    mov r1, r9  @hand
	ldr r0, [fp, #-8]
	mov r3, #000   @@ Your id here
    
    @                   address    player hand    user_input(bits) last 3 pal id
    @@void replace_card(FILE *fp, unsigned *hand, unsigned indices, unsigned uid);
    @bl replace_card
    
    @ close file
    ldr r0, [fp, #-8]
    bl fclose   @ fclose(filepointer)
    
    @ end program
    
    sub sp, fp, #4
    pop {fp, pc}
