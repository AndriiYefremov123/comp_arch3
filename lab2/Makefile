SDK_PREFIX=arm-none-eabi-
CC=$(SDK_PREFIX)gcc
OBJCOPY=$(SDK_PREFIX)objcopy
QEMU=~/opt/xPacks/qemu-arm/xpack-qemu-arm-7.2.0-1/bin/qemu-system-gnuarmeclipse

CPU=cortex-m4
TARGET=firmware

all:
	$(CC) -x assembler-with-cpp -c -g3 -mcpu=$(CPU) start.S -o start.o
	$(CC) -x assembler-with-cpp -c -g3 -mcpu=$(CPU) lab1.S -o lab1.o
	$(CC) start.o lab1.o -g3 -mcpu=$(CPU) -nostdlib -T lscript.ld -o $(TARGET).elf
	$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin

qemu:
	$(QEMU) --board STM32F4-Discovery --mcu STM32F407VG \
	--image $(TARGET).bin -gdb tcp::1234 -S -nographic

clean:
	rm -f *.o *.elf *.bin
