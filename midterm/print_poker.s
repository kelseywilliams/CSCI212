.cpu cortex-a53
.fpu neon-fp-armv8

.text
.align 2
.global print_poker
.type print_poker, %function

print_poker:
    push {r4, r5, r6, r7, r8, r9, r10, lr}

    ldr r1, =hand_types  @ Load the address of hand_types array
    mov r4, #0           @ Counter
    mov r5, #0           @ Previous card
    mov r6, #0           @ Card count
    mov r7, #0           @ Suit mask

check_hand:
    ldr r0, [sp, 0]     @ Load the hand value into r0
    and r8, r0, #15     @ Extract the value of the card
    and r9, r0, #48     @ Extract the suit of the card

    cmp r8, r5
    beq check_straight

    cmp r8, r5, lsl #1  @ Compare r8 (current_card) with r5 (prev_card + 1)
    bne check_flush

    cmp r6, #0
    bne update_card_count

check_flush:
    lsl r10, #1
    orr r7, r7, r10
    b update_suit_mask

check_straight:
    cmp r6, #4
    beq found_four_kind

    cmp r6, #3
    beq found_three_kind

    cmp r8, r5, lsl #1
    bne not_straight

update_card_count:
    add r6, r6, #1
    b next_card

not_straight:
    mov r6, #1

update_suit_mask:
    lsr r8, r9, #4
    orr r7, r7, r8

next_card:
    lsr r0, r0, #8
    add r4, r4, #1
    cmp r4, #5
    bne check_hand

    cmp r7, #15
    bne check_flush_or_straight_flush

    ldr r0, =hand_types + 40
    bl print_hand_type
    b exit

check_flush_or_straight_flush:
    cmp r6, #5
    beq found_straight_flush
    cmp r6, #1
    beq found_straight
    cmp r6, #2
    beq found_two_pairs
    cmp r6, #3
    beq found_full_house

    ldr r0, =hand_types
    bl print_hand_type

exit:
    pop {r4, r5, r6, r7, r8, r9, r10, pc}

found_full_house:
    ldr r0, =hand_types + 16
    b print_hand_type

found_two_pairs:
    ldr r0, =hand_types + 8
    b print_hand_type

found_straight:
    ldr r0, =hand_types + 32
    b print_hand_type

found_straight_flush:
    ldr r0, =hand_types + 24
    b print_hand_type

found_three_kind:
    ldr r0, =hand_types + 12
    b print_hand_type

found_four_kind:
    ldr r0, =hand_types + 28

print_hand_type:
    bl printf
