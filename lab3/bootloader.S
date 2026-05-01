.syntax unified
.cpu cortex-m4
.thumb

.global bootload

.section .rodata
image: .incbin "kernel.bin"  // вбудувати бінарний образ kernel
end_of_image:                // мітка кінця образу
str_boot_start: .asciz "bootloader started\n"
str_boot_end:   .asciz "bootloader end\n"

.section .text
.thumb_func
bootload:
    ldr r0, =str_boot_start
    bl dbgput_line               // вивести "bootloader started"

    ldr r0, =end_of_image        // r0 = адреса кінця образу
    ldr r1, =image               // r1 = адреса початку образу
    ldr r2, =_ram_start          // r2 = початок RAM (0x20000000)

// Варіант 13: LDM/STM, інкремент, 3 регістри по 4 байти (12 байт за ітерацію)
loop:
    ldmia r1!, {r4, r5, r6}  // завантажити 12 байт з flash, r1 += 12
    stmia r2!, {r4, r5, r6}  // записати 12 байт у RAM, r2 += 12
    cmp r0, r1               // перевірити чи скопійовано весь образ
    bhi loop                 // якщо ні — продовжити

    ldr r0, =str_boot_end
    bl dbgput_line           // вивести "bootloader end"

    ldr r2, =_ram_start
    add r2, #4               // перейти до вектора RESET в таблиці (offset +4)
    ldr r0, [r2]             // r0 = адреса __kernel_reset__

    ldr lr, =bootload_end    // зберегти адресу повернення
    add lr, #1               // bit0=1 для Thumb

    bx r0                    // перейти до виконання kernel в RAM

bootload_end:
    b bootload_end           // нескінченний цикл на випадок повернення
