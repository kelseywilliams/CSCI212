.cpu cortex-a53
.fpu neon-fp-armv8

.data
@any text here

.text
filename:   .asciz  "deck.txt"
waccess:    .asciz  "w"
raccess:    .asciz  "r"
testprint:  .asciz  "%d\n"


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
    
    @ call fjd(filepointer) -something like fjd for cards
    bl fjd
    
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
    @ call cards 
    bl print_cards
    
    ldr r0, [sp]
    bl print_poker
    
    
    bl user_input  @works fine - but goes twice...
    
    @printf or something stupid
    @ldr r0, =word1
    @b printf
    
    
    @ close file
    ldr r0, [fp, #-8]
    bl fclose   @ fclose(filepointer)
    
    @ end program
    
    sub sp, fp, #4
    pop {fp, pc}

	
	
