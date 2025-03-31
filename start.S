.syntax unified
.cpu cortex-m4
.thumb

.global vtable
.global __hard_reset__
.extern __stack_start

// Вектор переривань — починається з адреси стека і обробника скидання
.section .isr_vector, "a", %progbits
.global _isr_vector_start
_isr_vector_start:
.type vtable, %object
vtable:
    .word __stack_start           // Верхня межа стека (вказівник)
    .word __hard_reset__ + 1      // Адреса старту з +1 (режим Thumb)
.size vtable, .-vtable

// Початковий обробник (__hard_reset__)
// Ініціалізує стек і переходить до reset_handler
.type __hard_reset__, %function
__hard_reset__:
    ldr r0, =__stack_start        // Завантаження адреси початку стека
    mov sp, r0                    // Ініціалізація стеку
    b reset_handler               // Перехід до основної логіки
.size __hard_reset__, .-__hard_reset__
