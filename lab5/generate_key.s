.cpu cortex-a53
.fpu neon-fp-armv8
.data
digit:	.asciz	"%d"
hex:	.asciz	"%x"
nl:	.asciz	"\n"

.equ B, 0x42
.equ G, 0x47
.equ O, 0x4f
.equ P, 0x50
.equ R, 0x52
.equ Y, 0x59

.text
.align 2
.type generate_key, %function
.global generate_key

@ int generate_key()
generate_key:
	push {fp, lr}
	add fp, sp, #4

	mov r6, r0	@ store array in r6
	mov r4, #0
	mov r10, #0	@ set counter
	generate_digit:
		cmp r10, #4
		bge end_program

		@ get random number
		mov r0, #0
		mov r1, #5
		bl random	@ r0 = large number
		bl mod

		digest:
			
		@ shift random value into r4
		@ Shift r4 left by 3 and orr r0 and r4 to impose r0 onto the end of r4
		mov r4, r4, LSL #3
		orr r4, r4, r0

		add r10, r10, #1
		b generate_digit
	end_program:
		@ Print embedded value as a hexadecimal value.  Convert to binary to read
		ldr r0, =hex
		mov r1, r4
		bl printf

		@ Place 32 bit int with embedded values into address of key (r6)
		str r4, [r6]

	sub sp, fp, #4
	pop {fp, pc}
