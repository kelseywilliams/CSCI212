@@ user_input.s takes inputs from user and places @@
@@ input into code                                @@

.cpu cortex-a53
.fpu neon-fp-armv8

.data
option:     .asciz  "Select the card to replace.\nEnter in a a number (1 -5), or enter 0 to stop\n"
user:       .asciz  "%d"
tester:     .asciz  "%d\n"

.text

.align 2
.global user_input
.type user_input, %function

user_input:

    push {fp, lr}
    add fp, sp, #4
     
    push {r10} @fp-8
    push {r9} @fp-12
    push {r8} @fp-16
    
    @ Must input one number at a time
    @ printf("Select the card to replace. \nEnter in a a number (1 -5), or enter 0 to stop\n") @ Ask user if they what cards they want to replace
    ldr r0, =option
    bl printf

    @varibles for loop
    mov r10, #0        @ counter
    mov r9, #1         @ user answer
    mov r8, #0         @  bit stream  to send back - ex 010001100
    
    bit_loop:
        cmp r9, #0           @comp r9 to 0 - user input 
        beq end_bit_loop                                        
        
        @ scanf("%d", sp)
        sub sp, sp, #4      @ scan in answer
        ldr r0, =user 
        mov r1, sp       @ should have input
        bl scanf
        
        ldr r9, [sp]      @ move from
        
        @lets hope this bench flies
        add sp, sp, #4
        
        @add user input to line
        orr r8, r8, r9              
        mov r8, r8, LSL #3           @ move over for the next number
        
        @update & check counter
        add r10, r10, #1           @ i++
        cmp r10, #5
        beq end_bit_loop
        
        @else --> loop again
        b bit_loop         
        
    end_bit_loop:  @ end loop
    mov r8, r8, LSR #6  @@ fix shift issues
    
    @testing     - check for correct values
    @mov r1, r8  @ for testing
    @ Must input one number at a time
    @printf("%d\n") 
    @ldr r0, =tester
    @bl printf
    
    @send answer back to main
    mov r0, r8    @r8 into r0  
    
    @load back
    ldr r8, [fp, #-16]
    ldr r9, [fp, #-12]
    ldr r10, [fp, #-8]
    
    @ end program
    sub sp, fp, #4
    pop {fp, pc}
    
    
    
    
