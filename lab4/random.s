.cpu cortex-a53
.fpu neon-fp-armv8
.data
.text
.align 2
.type random, %function
.global random

@ int random(int lower, int upper)
random:
	push {fp, lr}
	add fp, sp, #4

	@ int num = (rand() % (upper - lower + 1)) + lower
	mov r6, r0	@ save lower for later addition to whole
	sub r5, r1, r0	@ upper - lower
	add r5, r5, #1	@ (upper - lower) + 1
	bl rand		@ rand() % (upper - lower + 1)
	mov r1, r5
	bl mod
	add r0, r0, r6	@ return (rand() % (upper - lower + 1)) + lower

	sub sp, fp, #4
	pop {fp, pc}
