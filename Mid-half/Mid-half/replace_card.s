.cpu cortex-a53
.fpu neon-fp-armv8

.data	@fscan(fp, "%u", &card)

un_inst: .asciz "%u"

.text
.align 2
.global replace_card
.type replace_card, %function

replace_card:

push {fp, lr}
add fp, sp, #4

@r0 = file ptr, r1 = hand, r2 = indices, r3 = uid

push {r0} @fp -8
push {r1} @fp -12
push {r2} @fp-16
push {r3} @fp-20
push {r4-r10}

mov r4, #7 @r4 = imask
mov r5, #65 @r5 = cmask
mov r10, #0 @r10 count # of replaced cards

@do loop

do_loop:

@get index = r7

@ r7 = r4 & indicies
ldr r0, [fp, #-16] @r0 = incides

@shift r7 to right by r10 * 3
mov r1, #3
mul, r10, r10, r1 @ r1 = 3 * r10
mov r7, r0, LSR, r1 @taking indicies & doing right shift
add r7, r7, r4 @indices >>(3*r10) & imask
@r7 = card # to replace

cmp r7, #0
beq end_do_loop

sub r2, r7, #1 @index -1
mov r3, #6

mul r2, r3, r2 @6*(index-1)

@r5 is cmask
mov r2, r5, LSL, r2 @r2 = cmask << 6 * (index-1)

not r2, r2 @ r2 = ~r2 - antimask
ldr r3, [fp, #-12] @hand

orr r8, r3, r2 @hand & ~(cmask<<(6&(index-1)) -> r8

@zero out card to replace
@read card file

ldr r0, [fp, #-8] @file ptr

ldr r1, =un_instr
sub sp, sp, #4
mov r2, sp

bl fscanf @fscanf(fileptr, "%u" sp)
sub r7, r7, #1
mov r0, #6
mul r7, r7, r0 @(index-1)*6

ldr r1, [sp] @load card just read from file

mov r7, r7, LSL, r1 @card << 6 * (index-1)
		@ r7 = card shifted to the right index
and r8, r8, r7	@put card in right place
add r10,r10, #1 @go to next inex

b do_loop

end_do_loop:
sub sp,fp, #4
pop {fp, pc}


