/* Лінкерний скрипт для STM32F4 */

MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1M
  RAM   (rwx): ORIGIN = 0x20000000, LENGTH = 128K
}

/* Старт стека — кінець області RAM */
__stack_start = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
  /* Вектор переривань на початку прошивки */
  .isr_vector : {
    _isr_vector_start = .;
    KEEP(*(.isr_vector))
  } > FLASH

  /* Код програми */
  .text : {
    *(.text*)
  } > FLASH

  .rodata : {
    *(.rodata*)
  } > FLASH

  .data : {
    *(.data*)
    _edata = .;
  } > RAM AT > FLASH

  .bss : {
    _sbss = .;
    *(.bss*)
    *(COMMON)
    _ebss = .;
  } > RAM
}
