.cpu cortex-a53
.fpu neon-fp-armv8
.data
round:	.asciz "%d: "
digit:	.asciz "%d "
nl:	.asciz "\n"
.text
.align 2
.global print_array
.type print_array, %function

@ void print_array(int length, int a[], int counter)
print_array:
	push {fp, lr}
	add fp, sp, #4

	mov r5, r0	@ r5 = length
	mov r6, r1	@ r6 = a[]

	mov r1, r2
	ldr r0, =round
	bl printf	@ print("%d: ", counter)
	mov r9, #0	@ set loop counter
	print_loop:
		cmp r9, r5
		bge end_program

		add r1, r6, r9, LSL #2
		ldr r1, [r1]		@ r1 = a[r9]
		add r9, r9, #1		@ r9++
		cmp r1, #0
		beq print_loop		@ if a[r9] == 0, continue
		ldr r0, =digit
		bl printf		@ printf("%d ", *(r6 + r9*4))
		b print_loop
	end_program:
	ldr r0, =nl
	bl printf	@ line break -- printf("\n")
	
	sub sp, fp, #4
	pop {fp, pc}

