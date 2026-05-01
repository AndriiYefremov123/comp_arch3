.syntax unified
.cpu cortex-m4
.thumb

.global vtable_kernel
.global __kernel_reset__

// Векторна таблиця переривань kernel
.section .interrupt_vector
vtable_kernel:
    .word __stack_start          // початкове значення Stack Pointer
    .word __kernel_reset__+1     // адреса обробника RESET (bit0=1 для Thumb)
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data:  .asciz "kernel started!\n"
    final: .asciz "Value in register r6: "

.section .text
.thumb_func
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line               // вивести "kernel started!"

    // Варіант 4: {(a|b)*c, якщо (a*b)>=10; (a*b)*c, якщо (a*b)<10}
    mov r0, #3      // a = 3
    mov r1, #4      // b = 4
    mov r2, #5      // c = 5

    mul r3, r0, r1  // r3 = a * b = 12
    mov r4, #10
    cmp r3, r4      // порівняти a*b з 10
    blt less_than_10

greater_equal_10:
    orr r5, r0, r1  // r5 = a | b = 7
    mul r6, r5, r2  // r6 = (a|b) * c = 35
    b print_result

less_than_10:
    mul r6, r3, r2  // r6 = (a*b) * c

print_result:
    ldr r0, =final
    bl dbgput
    mov r0, r6      // передати результат в r0 для виводу
    bl dbgput_num

end:
    b end           // нескінченний цикл
