.cpu	cortex-a53
.fpu	neon-fp-armv8

.data
prompt1:	.asciz "Enter two positive integers: "
user_input:	.asciz "%d %d"
output:		.asciz "Prime numbers between %d and %d are: "

.balign 4

n:	.word 0
n2:	.word 0

.text
.align 2
.global main
.type main, %function

main:
	push {fp, lr}
	add fp, sp, #4

	ldr r0, =prompt1
	bl printf

	ldr r0, =user_input
	ldr r1, =n
	ldr r2, =n2
	bl scanf

	ldr r0, =output
	ldr r1, =n
	ldr r1, [r1]
	ldr r2, =n2
	ldr r2, [r2]
	bl printf

	ldr r0, =n
	ldr r0, [r0]

	
	pop {fp, pc}
	sub sp, fp, #4
