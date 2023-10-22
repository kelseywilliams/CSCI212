.cpu cortex-a53
.fpu neon-fp-armv8


.data


.text
.align 2
.global sort
.type sort, %function


sort:
     push {fp, lr}
     add fp, sp, #4

     push {r0}    @ fp -8
     push {r1}    @ fp -12
     push {r9}    @ fp -16
     push {r10}   @ fp -20


     @ r9 = i
     @ r10 = j

     @ i = 0
     mov r9, #0

     sort_outer_loop:
         ldr r1, [fp, #-12]   @ r1 = n
         sub r1, r1, #1
         cmp r9, r1   @ if r9 < n-1
         bge end_sort_outer_loop

         add r10, r9, #1      @ j = i + 1

         sort_inner_loop:
             ldr r1, [fp, #-12]   @ r1 = n
             cmp r10, r1
             bge end_sort_inner_loop

             @ if (a[i] > a[j])
             @ r0 = a[i]
             mov r1, r9, LSL #2  @ compute byte offset
             ldr r0, [fp, #-8]   @ r0 = address of array
             ldr r0, [r0, r1]    @ r0 = *(array address + 4*r10)

             @ r1 = a[j]
             mov r2, r10, LSL #2 @ compute byte offset
             ldr r1, [fp, #-8]   @ r1 = address of array
             ldr r1, [r1, r2]    @ r1 = a[r10]

             cmp r0, r1
             ble end_if

                @ swap(&a[i], &a[j])
                ldr r0, [fp, #-8]    @ r0 = address of array
                add r0, r0, r9, LSL #2    @ r0 = r0 + r10*4

                ldr r1, [fp, #-8]     @ r1 = address of array
                add r1, r1, r10, LSL #2

                bl swap

             end_if:

             add r10, r10, #1    @ j++
             b sort_inner_loop

         end_sort_inner_loop:

         add r9, r9, #1  @ i++
         b sort_outer_loop

     end_sort_outer_loop:


     ldr r9, [fp, #-16]
     ldr r10, [fp, #-20]

     sub sp, fp, #4
     pop {fp, pc}

