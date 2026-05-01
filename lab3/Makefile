SDK_PREFIX=arm-none-eabi-
CC=$(SDK_PREFIX)gcc
OBJCOPY=$(SDK_PREFIX)objcopy
QEMU=~/opt/xPacks/qemu-arm/xpack-qemu-arm-7.2.0-1/bin/qemu-system-gnuarmeclipse
CPU=cortex-m4
TARGET=firmware

all: kernel.bin $(TARGET).elf $(TARGET).bin

kernel.bin:
	$(CC) -x assembler-with-cpp -c -g3 -mcpu=$(CPU) kernel.S -o kernel.o
	$(CC) -x assembler-with-cpp -c -g3 -mcpu=$(CPU) print.S -o print.o
	$(CC) kernel.o print.o -g3 -mcpu=$(CPU) -nostdlib -T lscript_kernel.ld -o kernel.elf
	$(OBJCOPY) -O binary kernel.elf kernel.bin

$(TARGET).elf: start.o print.o bootloader.o
	$(CC) start.o print.o bootloader.o -g3 -mcpu=$(CPU) -nostdlib -T lscript.ld -o $(TARGET).elf

start.o: start.S
	$(CC) -x assembler-with-cpp -c -g3 -mcpu=$(CPU) start.S -o start.o

print.o: print.S
	$(CC) -x assembler-with-cpp -c -g3 -mcpu=$(CPU) print.S -o print.o

bootloader.o: bootloader.S kernel.bin
	$(CC) -x assembler-with-cpp -c -g3 -mcpu=$(CPU) bootloader.S -o bootloader.o

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin

qemu:
	$(QEMU) --board STM32F4-Discovery --mcu STM32F407VG \
	--image $(TARGET).bin -gdb tcp::1234 -S -nographic \
	--semihosting-config enable=on,target=native

clean:
	rm -f *.o *.elf *.bin
