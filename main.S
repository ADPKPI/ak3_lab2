.syntax unified
.cpu cortex-m4
.thumb

.global reset_handler

// Основна функція, яка викликає my_func_5 з різними наборами даних і зберігає результати у регістри r3–r6
.type reset_handler, %function
reset_handler:
    // Приклад №1: P = 2*4 = 8 → .case1
    movs r0, #2
    movs r1, #4
    movs r2, #6
    bl my_func_5
    mov r3, r0   // очікуємо r3 = 35

    // Приклад №2: P = 3*5 = 15 → .case2
    movs r0, #3
    movs r1, #5
    movs r2, #2
    bl my_func_5
    mov r4, r0   // очікуємо r4 = 13

    // Приклад №3: P = 5*4 = 20 → .case3
    movs r0, #5
    movs r1, #4
    movs r2, #1
    bl my_func_5
    mov r5, r0   // очікуємо r5 = 40

    // Приклад №4: P = 7*8 = 56 → .case4
    movs r0, #7
    movs r1, #8
    movs r2, #4
    bl my_func_5
    mov r6, r0   // очікуємо r6 = 39

end_loop:
    b end_loop
.size reset_handler, .-reset_handler
