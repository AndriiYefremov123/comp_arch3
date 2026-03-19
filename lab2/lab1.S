.global lab1

.syntax unified
.thumb
.thumb_func
#define A #3
#define B #4
#define C #5

lab1:
    push {lr}

    mov r0, A      // a
    mov r1, B      // b
    mov r2, C      // c

    // r3 = a * b
    mul r3, r0, r1

    // перевірка: (a * b) >= 10 ?
    mov r4, #10
    cmp r3, r4

    blt less_than_10

greater_equal_10:
    // (a | b)
    orr r5, r0, r1

    // (a | b) * c
    mul r6, r5, r2
    b end

less_than_10:
    // (a * b) * c
    mul r6, r3, r2

end:
    // результат в r6
    pop {pc}
