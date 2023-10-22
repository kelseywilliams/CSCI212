.cpu cortex-a53
.fpu neon-fp-armv8

.data

.text
.align 2
.global mod
.type mod, %function

mod:
    push {fp, lr}
    add fp, sp, #4

    @ r0 = a, r1 = b, return (a % b)

    @ r2 = r0 / r1
    udiv r2, r0, r1
    @ r2 = floor(r0/r1)*r1
    mul r2, r2, r1
    @ r0 = r0 - r2
    sub r0, r0, r2

    sub sp, fp, #4
    pop {fp, pc}
