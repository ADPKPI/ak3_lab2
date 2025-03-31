SDK_PREFIX?=arm-none-eabi-
CC = $(SDK_PREFIX)gcc

LD = $(SDK_PREFIX)ld
SIZE = $(SDK_PREFIX)size
OBJCOPY = $(SDK_PREFIX)objcopy
QEMU = /root/opt/xPacks/qemu-arm/xpack-qemu-arm-8.2.6-1/bin/qemu-system-gnuarmeclipse

BOARD ?= STM32F4-Discovery
MCU = STM32F407VG
TARGET = firmware
CPU_CC = cortex-m4
TCP_ADDR = 1234

SOURCES = start.S main.S my_func_5.S
OBJS = start.o main.o my_func_5.o

all: $(TARGET).bin

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary -F elf32-littlearm $< $@

$(TARGET).elf: $(OBJS) lscript.ld
	$(CC) $(OBJS) -mcpu=$(CPU_CC) -mthumb -Wall --specs=nosys.specs -nostdlib -lgcc \
		-T lscript.ld -o $@
	$(SIZE) $@

%.o: %.S
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) -mthumb -Wall $< -o $@

qemu: $(TARGET).bin
	$(QEMU) --verbose --verbose --board $(BOARD) --mcu $(MCU) -d unimp,guest_errors \
		--image $(TARGET).bin --semihosting-config enable=on,target=native -nographic \
		-gdb tcp::$(TCP_ADDR) -S

clean:
	-rm *.o
	-rm *.elf
	-rm *.bin
