.cpu cortex-a53
.fpu neon-fp-armv8


.data


.text
.align 2
.global swap
.type swap, %function


swap:
     push {fp, lr}
     add fp, sp, #4

     @ r0 = &a, r1 = &b

     ldr r2, [r0]    @ r2 = *(&a)
     ldr r3, [r1]    @ r3 = *(&b)
     str r2, [r1]
     str r3, [r0]


     sub sp, fp, #4
     pop {fp, pc}

