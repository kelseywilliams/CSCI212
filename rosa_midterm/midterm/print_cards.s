@@print_cards_csVerison
@@ print_cards.s prints the cards  @@

.cpu cortex-a53
.fpu neon-fp-armv8

.data
card:       .asciz  "%d\n"
cardfullN:  .asciz  "%u %s\n"
cardfullL:	.asciz "%s %s\n"
spade:      .asciz "SPADE"
diamond:    .asciz "DIAMOND"
club:       .asciz "CLUB"
heart:      .asciz "HEART"
ace: 		.asciz "A"
jack:		.asciz "J"
king:		.asciz "K"
queen:		.asciz "Q"

.text

.align 2
.global print_cards
.type print_cards, %function

print_cards:

    push {fp, lr}
    add fp, sp, #4
    
    @save any vals
    push {r10} @fp-8      @counter
    push {r5} @fp-12      @value
    push {r6} @fp-16      @suit
    push {r7} @fp-20      @mask
    push {r8} @fp-24      @cvalue
    push {r9} @fp-28      @whole bit stream
    push {r1-r3}          @ angry boi's
    
    @r0 = card input (value and suit)
    mov r9, r0
    
    mov r10, #0    @ i = 0    -counter
    mov r7, #15    @ mask = 15
    
    @ printf("%d\n")   @ whole bit stream (all cards)
	ldr r0, =card
	
	@bl printf
    
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
		
		@suit = csuit >> 6*i+4                                    @ <------------------- suit stuff
        mov r6, r6, LSR r2               
        
        @ clear regs for use
        mov r1, #0
        mov r2, #0
        mov r3, #3
        
        @value = cvalue & mask;
        @suit                                        @ <------------------- suit stuff
        and r1, r8, r7    @value (r1) = cval and mask
        and r2, r6, r3    @suit  (r2) = suit and #3
        
        cmp r2, #0
        beq spadeB
        
        cmp r2, #1
        beq diamondB
        
        cmp r2, #2
        beq clubB
        
        cmp r2, #3
        beq heartB
        
        @b after_suit
        
        spadeB: ldr r2, =spade
        b after_suit
        
        diamondB: ldr r2, =diamond
        b after_suit
        
        clubB: ldr r2, =club
        b after_suit
        
        heartB: ldr r2, =heart
        b after_suit
        
         
		after_suit:
		
		cmp r1, #1
		beq aceB
		
		cmp r1, #11
		beq jackB
		
		cmp r1, #12
		beq queenB
		
		cmp r1, #13
		beq kingB
		
		b after_valueN
		
		aceB: ldr r1, =ace
		b after_valueL
		
		jackB: ldr r1, =jack
		b after_valueL
		
		queenB: ldr r1, =queen
		b after_valueL
		
		kingB: ldr r1, =king
		b after_valueL
		
		after_valueL:
		
		@ printf("%u %s\n")   @ full card card
		ldr r0, =cardfullL
		@ldr r1,   @value
		@ldr r2,   @suit
		bl printf
		b for_real_after_value
		
		after_valueN:
		@ printf("%u %s\n")   @ full card card
		ldr r0, =cardfullN
		@ldr r1,   @value
		@ldr r2,   @suit
		bl printf
		
		for_real_after_value:
		
		add r10, r10, #1   @ i++
		b cfor_loop
		
		end_cfor_loop:
    
    @get back vals
    ldr r9, [fp, #-28]
    ldr r8, [fp, #-24]
    ldr r7, [fp, #-20]
    ldr r6, [fp, #-16]
    ldr r5, [fp, #-12]
    ldr r10, [fp, #-8]
    
    
    @ end program
    sub sp, fp, #4
    pop {fp, pc}
    

