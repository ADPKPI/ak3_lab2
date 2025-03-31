.syntax unified
.cpu cortex-m4
.thumb

.global my_func_5

// my_func_5(a, b, c) повертає R за такою логікою:
//
// P = a * b
// якщо P < 10:      R = (P << 2) + (c >> 1)
// якщо P < 20:      R = (P >> 1) ^ (b << 1)
// якщо P < 50:      R = (a + b + c) * (a & b)
// інакше (P >= 50): R = factorial(c) + (a | b)

.type my_func_5, %function
my_func_5:
    push {r4, r5, r6, r7, lr}   // Збереження регістрів

    mov r4, r0                 // a
    mov r5, r1                 // b
    mov r6, r2                 // c

    mul r7, r4, r5             // P = a * b

    movs r0, #10
    cmp r7, r0
    blt .case1

    movs r0, #20
    cmp r7, r0
    blt .case2

    movs r0, #50
    cmp r7, r0
    blt .case3

.case4:
    mov r0, r6                 // c → r0
    bl factorial               // виклик факторіалу

    orr r1, r4, r5             // a | b
    add r0, r0, r1             // результат
    b .done

.case1:
    lsl r7, r7, #2             // P << 2
    lsr r1, r6, #1             // c >> 1
    add r0, r7, r1
    b .done

.case2:
    lsr r7, r7, #1             // P >> 1
    lsl r1, r5, #1             // b << 1
    eor r0, r7, r1
    b .done

.case3:
    adds r7, r4, r5
    adds r7, r7, r6           // a + b + c
    and r1, r4, r5            // a & b
    mul r0, r7, r1
    b .done

.done:
    pop {r4, r5, r6, r7, lr}
    bx lr

// factorial(n) → r0 = n!
.type factorial, %function
factorial:
    push {r1, r2, lr}

    cmp r0, #1
    ble .fact_done

    mov r1, r0

.fact_loop:
    subs r1, r1, #1
    mul r0, r0, r1
    cmp r1, #1
    bgt .fact_loop

.fact_done:
    pop {r1, r2, lr}
    bx lr
