.cpu cortex-a53
.fpu neon-fp-armv8
.data
.text
.align 2
.type random, %function
.global random

@ int rand_gen(int lower, int upper)
random:
	push {fp, lr}
	add fp, sp, #4

	push {r4}

	@ int num = (rand() % (upper - lower + 1)) + lower
	mov r5, r0	@ save lower for later addition to whole
	sub r4, r1, r0	@ upper - lower
	add r4, r4, #1	@ (upper - lower) + 1
	bl rand		@ rand() % (upper - lower + 1)
	mov r1, r4
	bl mod
	add r0, r0, r5	@ return (rand() % (upper - lower + 1)) + lower

	pop {r4}

	sub sp, fp, #4
	pop {fp, pc}
