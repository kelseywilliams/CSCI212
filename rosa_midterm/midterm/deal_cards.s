.cpu cortex-a53
.fpu neon-fp-armv8


.data
read_cards:   .asciz  "%d %d"

.balign
cvalue:   .word  0
csuit:    .word  0


.text
.align 2
.global deal_cards
.type deal_cards, %function


deal_cards:
     push {fp, lr}
     add fp, sp, #4

     @ r0 = filepointer, r1 = address of the card
     push {r0}   @ fp - 8
     push {r1}   @ fp - 12
     push {r4}   @ fp - 16
     push {r10}  @ fp - 20

     mov r4, #0   @ card bistream is in r4

     mov r10, #0  @ i = 0

     start_dealcards_loop:
         cmp r10, #5
         bge end_dealcards_loop

         @ fscanf(fpointer, "%d %d", &cvalue, & csuit)
         ldr r0, [fp, #-8]   @ filepointer
         ldr r1, =read_cards
         ldr r2, =cvalue
         ldr r3, =csuit
         bl fscanf

         @ load the card value into r0
         ldr r0, =cvalue
         ldr r0, [r0]
         @ load the suit value into r1
         ldr r1, =csuit
         ldr r1, [r1]

         @ r2 = 6*i
         mov r2, #6
         mul r2, r2, r10
         
         mov r0, r0, LSL r2

         orr r4, r4, r0

         @ r2 = 6*i + 4
         add r2, r2, #4

         mov r1, r1, LSL r2

         orr r4, r4, r1   @ r4 = r4 | (value<<6*i) | (suit<<6*i+4)

         add r10, r10, #1

         b start_dealcards_loop

     end_dealcards_loop:

     @ store r4 into the card memory address

     ldr r0, [fp, #-12]   @ card memory address
     str r4, [r0]


     ldr r4, [fp, #-16]
     ldr r10, [fp, #-20]

     sub sp, fp, #4
     pop {fp, pc}

