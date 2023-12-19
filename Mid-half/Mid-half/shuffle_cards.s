@@ Copied from lec 11 - fjd.s @@
@@ Comment and change as needed @@

.cpu cortex-a53
.fpu neon-fp-armv8

.data
int_instr:    .asciz  "%d %d\n"

.text

.align 2
.global shuffle_cards
.type shuffle_cards, %function

shuffle_cards:

    push {fp, lr}
    add fp, sp, #4

    @ r0 = filepointer

    push {r0}  @ store the filepointer on the stack  fp - 8
    push {r10}   @ fp - 12
    push {r4}    @ fp - 16
    push {r5}    @ fp - 20
    push {r6}    @ fp - 24

    mov r10, #0   @ i = 0

    @ Allocate memory on the stack to store 52 cards
    @ bytes = 52 x 4 = 208
    sub sp, sp, #208

    start_for_loop:
        cmp r10, #52  @ count < 52
        bge end_for_loop

        @ Calculate the value of the card
        @ value = i / 4 + 1
        mov r4, r10, LSR #2   @ divide by 4 = right bit shift by 2 bits
        add r4, r4, #1

        @ Calculate the value of the suit
        @ suit = i % 4 --> r5
        mov r0, r10   @ r0 = i
        mov r1, #4
        bl mod        @ mod(i, 4)
        mov r5, r0

        @ Strategy is to combine the value & suit into a single
        @ bit stream by shifting the suit bits to the left by 4
        @ and then merge with the value

        mov r5, r5, LSL #4   @ shift the suit by 4 bits

        @ Merge the card value (r4) with the suit (r5)
        orr r4, r4, r5   @ r4 = r4 | r5

        @ store the card into memory
        mov r3, r10, LSL #2    @ r3 = r10*4 = byte offset from the allocated mem
        str r4, [sp, r3]       @ store the card into sp[i]

        add r10, r10, #1   @ i++

        b start_for_loop

    end_for_loop:

    mov r10, #0   @ count = 0

    start_while_loop:
        cmp r10, #52   @ count < 52
        bge end_while_loop

        bl rand   @ generate random number
        mov r1, #52
        bl mod    @ mod(n, 52) = 0 and 51 --> r0

        @ load the card value from memory at location r0
        mov r2, r0, LSL #2    @ calculate the byte offset corresponding to r0
        ldr r3, [sp, r2]

        @ r3 contains the hybrid card = suit + card value

        @ To get the suit, shift r3 to the right by 4 bits
        mov r3, r3, LSR #4

        cmp r3, #4   @ Use the value 4 to indicate the card has been selected
        beq else_if

            add r10, r10, #1   @ count++
            ldr r3, [sp, r2]   @ reload the card into r3
            @ fprintf(filepointer, "%d %d\n", value, suit)

            mov r6, r2         @ save the value of my random selection

            ldr r0, [fp, #-8]    @ filepointer
            ldr r1, =int_instr   @ "%d %d\n"

            @ card value --> r2, suit --> r3
            @ Generate a mask of value 15 to extract the last 4 bits
            mov r2, #15
            and r2, r2, r3    @ card value --> r2

            @ get the suit --> r3
            mov r3, r3, LSR #4   @ shifting to the right by 4 bits

            bl fprintf

            @ Set the suit value to #4 to prevent this card from being
            @ drawn again

            @ load the card out again
            ldr r3, [sp, r6]    @ reload the card out
            mov r2, #15
            and r2, r2, r3      @ get the card value
            mov r3, #4          @ set suit value to 4 to indicated selection
            mov r3, r3, LSL #4  @ shift the suit by 4 bits to the left
            orr r2, r2, r3      @ merge card value with suit value
            str r2, [sp, r6]    @ store the modified card back on stack
            

        else_if:

        b start_while_loop

    end_while_loop:

    ldr r6, [fp, #-24]    @ restore r6
    ldr r5, [fp, #-20]    @ restore r5
    ldr r4, [fp, #-16]    @ restore r4
    ldr r10, [fp, #-12]   @ restore r10

    sub sp, fp, #4
    pop {fp, pc}
