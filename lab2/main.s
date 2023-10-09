.cpu    cortex-a53
.fpu    neon-fp-armv8

.data
prompt_fib: .asciz "Problem 1\nEnter Fibonacci term:"
input_fib:  .asciz " %d"
output_fib: .asciz "The %dth fibonacci number is %d\n"

prompt1_gcd:	.asciz  "Problem 2\nEnter first positive integer:"
prompt2_gcd:	.asciz	"Enter second positive integer:"
input_gcd:  .asciz  "%d"
output_gcd: .asciz  "The GCD is %d.\n"

.balign 4

n:      .word 0
a:	.word 0
b:	.word 0

.text
.align 2
.global main
.type main, %function

main:
	push {fp, lr}
	add fp, sp, #4

@--- FIBONACCI ---

	@ Prompt the user for n
	ldr r0, =prompt_fib
	bl printf

	@ Get n and store it statically
	ldr r0, =input_fib
	ldr r1, =n
	bl scanf

	@ Load the value of n in r0
	ldr r0, =n
	ldr r0, [r0]
	bl fib

	@ Print the value returned by fib
	mov r3, r1
	mov r1, r0
	mov r2, r3
	ldr r0, =output_fib
	bl printf

@--- GCD ---
	@ Prompt the user for two numbers
	ldr r0, =prompt1_gcd
	bl printf

	@ Store user input in variables a and b
	ldr r0, =input_gcd
	ldr r1, =a
	bl scanf

	ldr r0, =prompt2_gcd
	bl printf

	ldr r0, =input_gcd
	ldr r1, =b
	bl scanf

	@ Pass values of a and b into gcd
	ldr r0, =a
	ldr r0, [r0]
	ldr r1, =b
	ldr r1, [r1]
	bl gcd

	@ Print values returned by gcd
	mov r1, r0
	ldr r0, =output_gcd
	bl printf

	@ Exit the function
	pop {fp, pc}
	sub sp, fp, #4
