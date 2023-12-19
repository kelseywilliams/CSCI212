@@ user_input.s takes inputs from user and places @@
@@ input into code                                @@

.cpu cortex-a53
.fpu neon-fp-armv8

.data
message:	.asciz "You have %s"
royflu:		.asciz "a Royal Straight Flush!\n"
strflu:		.asciz "a Straight Flush\n"
fancy4:		.asciz "Four of a Kind\n"
bighouse:	.asciz "a Full House\n"
goldfish:	.asciz "a Flush\n"
lineup:		.asciz "a Straight\n"
fancy3:		.asciz "Three of a Kind\n"
doubletwo:	.asciz "Two Pairs\n"
perry:		.asciz "a Pair\n" @ "A platypus playing poker?"
impossible:	.asciz "nothing\n"
testmessage:	.asciz "%u\n"

.text

.align 2
.global print_poker
.type print_poker, %function


print_poker:

    push {fp, lr}
    add fp, sp, #4
    
    push {r0} @fp-8
    push {r1} @fp-12
    push {r2} @fp-16
    push {r3} @fp-20
    push {r4} @fp-24
    push {r5} @fp-28
    push {r6} @fp-32
    push {r7} @fp-36
    push {r9} @fp-40
    push {r10} @fp-44

    @remainder r0 = cards bit stream
    
    @format the bit stream for sort.s
    @for loop printing onto the stack the values within the bit stream
    
    @r9 now contains the bit stream
    mov r9, r0
    
    mov r10, #0    @ i = 0    -counter
    mov r7, #15    @ mask = 15
    
    @allocates enough memory for the bit stream to become an array
    @the array will consist of 5 values and then 5 suits
    sub sp, sp, #40 
    
    
    @@@for(i=0;i<5;i++)
    cfor_loop:
		cmp r10, #5  @ i < 5
		beq end_cfor_loop
		
		@load values for mult
		mov r0, #6
		mul r1, r0, r10  @ 6*r10 so r1 = 6*i 
		mov r3, #3
		
		@unsigned cvalue = card & (mask << 6*i)
		@                  card & mask LSL 
		mov r8, r7, LSL r1   @r8 = mask LSL r1    
		@mov r8, r8, LSL #2 
		and r8, r8, r9
		
		@unsigned csuit = card & (3 << 6*i+4)             @ <------------------- suit stuff
		add r2, r1, #4   @ r2 = (6*i) +4
		mov r6, r3, LSL r2      @suit = 3 << (6*i) +4
		and r6, r6, r9          @suit = suit & r9
		
		@cvalue = cvalue >> 6*i;
		@ shift r8 by (6*r10)
		mov r8, r8, LSR r1
		
		@suit = csuit >> 6*i+4 
        mov r6, r6, LSR r2               
        
        @ clear regs for use
        mov r1, #0
        mov r2, #0
        mov r3, #3
        
        @value = cvalue & mask;
        @suit
        and r1, r8, r7    @value (r1) = cval and mask
        and r2, r6, r3    @suit  (r2) = suit and #3
        
        @ make the value be stored onto the stack
        mov r3, #4
        mul r0, r10, r3
        str r1, [sp, r0]
        
        @make the suit be stored onto the stack 20 memory locations lower
        @so that the stack cointains 5 values followed by 5 suits
        mov r3, #4
        mul r0, r10, r3
        add r0, #20
        str r2, [sp, r0]
       
		add r10, r10, #1   @ i++
		b cfor_loop
		
		end_cfor_loop:
    
    @use sort.s
    
    @ r0 needs to be the address of the start of the ---->cvalues on the stack<----
    mov r0, fp
    sub r0, #84
    mov r1, #5
    bl sort
    
    @Jonathan's lessons in gambling

@Logic for this

@Take hand

@push all values onto stack

@NOTE SORT THE STACK

@take 5 values at a time

@ suits out and onto regs r0 to r4
	
	ldr r0, [fp, #-64]
	ldr r1, [fp, #-60]
	ldr r2, [fp, #-56]
	ldr r3, [fp, #-52]
	ldr r4, [fp, #-48]

@Do we have a flush

@Suits and values

@Flush: Suits

@Every suit is equal

@0 1 2 3

@5 of any above

mov r5, #0 @ Boolean for flush

cmp r0, r1
bne not_flush

cmp r0, r2
bne not_flush

cmp r0, r3
bne not_flush

cmp r0, r4
bne not_flush


mov r5, #1

@- is a straight flush


@-- is a royal straight flush

@=====================================

@take every other 5 stack addresses

@We care about values here

@Do we have a straight

@Straight: Values in a line

@5 6 7 8 9 < ---

@Is the next number +1 of the current?

@10 J Q K A
@10 11 12 13 1

@1 2 3 4 5

not_flush:

@ put cvalues into regs r0 to r4
	
	@ldr r0, [fp, #-68]
	@ldr r1, [fp, #-72]
	@ldr r2, [fp, #-76]
	@ldr r3, [fp, #-80]
	@ldr r4, [fp, #-84]

@sort view look like 13 12 11 10 1

@if the first number is 13
cmp r0, #13
beq ace

b nace

ace:
cmp r4, #1
beq royal

royal:
add r6, r1, #1

cmp r0, r6
bne nace

add r6, r2, #1

cmp r1, r6
bne nace

add r6, r3, #1

cmp r2, r6
bne nace

cmp r5, #1
bne found_straight


b found_royal

nace:
add r6, r1, #1

cmp r0, r6
bne is_flush

add r6, r2, #1

cmp r1, r6
bne is_flush

add r6, r3, #1

cmp r2, r6
bne is_flush

add r6, r4, #1

cmp r3, r6
bne is_flush

cmp r5, #1
bne found_straight

b straight_flush

is_flush:

cmp r5, #1
beq found_flush


@Do we have 4 of a kind

four_kind:

@9 9 9 9 2

first_numfour:
cmp r0, r1
bne second_numfour

cmp r0, r2
bne second_numfour

cmp r0, r3
beq found_four

@if all are the same we found a 4 of a kind
@otherwise

second_numfour:
@do as with the first


@5 4 4 4 4

cmp r1, r2
bne three_kind

cmp r1, r3
bne three_kind

cmp r1, r4
beq found_four

@3 of a kind
three_kind:

@5 5 5 2 1
first_num3:

cmp r0, r1
bne second_num3

cmp r0, r2
beq house

second_num3:

@9 2 2 2 1

cmp r1, r2
bne third_num3

cmp r1, r3
beq house

third_num3:

@8 7 4 4 4

cmp r2, r3
bne pair

cmp r3, r4
beq house

b pair

@- full house
@8 8 8 2 2
house:

cmp r0, r1
bne found_three

@4 4 3 3 3

cmp r3, r4
bne found_three

b found_house

@9 9 8 7 3

pair:


cmp r0, r1
beq two_pair

@10 9 9 4 3

cmp r1, r2
beq two_pair2

@10 8 7 7 4

cmp r2, r3
beq found_pair

@10 8 7 5 5

cmp r3, r4
bne nothing
b found_pair

@- two pair

two_pair:

@9 9 7 7 5

cmp r1, r2
beq found_two

@9 9 7 5 5

cmp r3, r4
bne found_pair
b found_two

@9 7 7 5 5

two_pair2:

cmp r3, r4
beq found_two

@Nothing

b nothing

found_royal:

ldr r1, =royflu
b printer

straight_flush:

ldr r1, =strflu
b printer

found_four:

ldr r1, =fancy4
b printer

found_house:


ldr r1, =bighouse
b printer

found_flush:

ldr r1, =goldfish @Because when it dies, you ____ it down the toilet
b printer

found_straight:

ldr r1, =lineup @you line up in a straight line
b printer

found_three:

ldr r1, =fancy3
b printer

found_two:

ldr r1, =doubletwo
b printer

found_pair:

ldr r1, =perry @sounds like a pair
b printer

nothing:

ldr r1, =impossible @_______ is impossible

printer:

@ printf("You have %s", correctHand)
ldr r0, =message
bl printf

@ end program
	
    ldr r10, [fp, #-44]
	ldr r9, [fp, #-40]
    ldr r7, [fp, #-36]
    ldr r6, [fp, #-32]
	ldr r5, [fp, #-28]
    ldr r4, [fp, #-24]
    ldr r3, [fp, #-20]
	ldr r2, [fp, #-16]
    ldr r1, [fp, #-12]
    ldr r0, [fp, #-8]
	
    sub sp, fp, #4
    pop {fp, pc}

