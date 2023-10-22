.cpu cortex-a53
.fpu neon-fp-armv8

.data
card:       .asciz  "%d\n"
cardfull:   .asciz  "%u %s\n"   @normal card (no face)
cardfull2:  .asciz  "%s %s\n"  @face card

ace:        .asciz  "A"
jack:       .asciz  "J"
queen:      .asciz  "Q"
king:       .asciz  "K"

diamond:    .asciz  "DIAMOND"
club:       .asciz  "CLUB"
heart:      .asciz  "HEART"
spade:      .asciz  "SPADE"

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
    push {r9} @fp-28      @bit stream
    push {r1-r3} 

    @r0 = card input (value and suit)
    mov r9, r0
    
    mov r10, #0    @ i = 0    -counter
    mov r7, #15    @ mask = 15
    
    @ printf("%d\n")   @ whole bit stream (all cards)
	@ldr r0, =card
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
		
	@unsigned csuit = card & (3 << 6*i+4)   
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
		
	mov r0, #0     @check for face card - for printing correctly
	
	@check for face cards and change suits	
	suit_loop:     @@ r2 = suit
	    cmp r2, #0
	    beq dia
	    
	    cmp r2, #1
	    beq hea
	    
	    cmp r2, #2
	    beq clu
	    
	    cmp r2, #3
	    beq spa
	    
	    b end_suit_loop
	    
	    @changes if needed
	    dia:
		ldr r2,=diamond 
		b end_suit_loop
	    hea:
		ldr r2,=heart 
		b end_suit_loop
	    clu:
		ldr r2,=club 
		b end_suit_loop
	    spa:
		ldr r2,=spade
		b end_suit_loop
	end_suit_loop:
	
	face_loop:  @@ r1 = value
	    cmp r1, #1
	    beq aces
	    
	    cmp r1, #11
	    beq jac
	    
	    cmp r1, #12
	    beq que
	    
	    cmp r1, #13
	    beq kin
	    
	    b end_face_loop
	    
	    @changes if needed
	    aces:
		ldr r1,=ace
		add r0, r0, #1    @i++
		b end_face_loop
	    jac:
		ldr r1,=jack
		add r0, r0, #1    @i++ 
		b end_face_loop
	    que:
		ldr r1,=queen
		add r0, r0, #1    @i++
		b end_face_loop
	    kin:
		ldr r1,=king
		add r0, r0, #1    @i++
		b end_face_loop
	end_face_loop:
		
	@face vs plain
	cardprint_if:
	    cmp r0, #0
	    beq plainC
	    
	    @otherwise is face
	    
	    @ printf("%s %s\n")   @ face card
	    ldr r0, =cardfull2
	    @ldr r1,   @value
	    @ldr r2,   @suit
	    bl printf
		
	    b end_cardprint_if
	    
	    plainC:
		@ printf("%u %s\n")   @ normal card
		ldr r0, =cardfull
		@ldr r1,   @value
		@ldr r2,   @suit
		bl printf
		
		b end_cardprint_if
	
	end_cardprint_if:	
		
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
