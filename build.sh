#!/bin/bash
echo "Building AuroraOS..."

nasm -f bin boot.asm -o boot.bin
if [ $? -ne 0 ]; then
    echo "Bootloader build failed"
    exit 1
fi

nasm -f bin kernel.asm -o kernel.bin
if [ $? -ne 0 ]; then
    echo "Kernel build failed"
    exit 1
fi

echo "Creating disk image..."
rm -f os.img
dd if=/dev/zero of=os.img bs=512 count=2880 2>/dev/null
dd if=boot.bin of=os.img bs=512 count=1 conv=notrunc 2>/dev/null
dd if=kernel.bin of=os.img bs=512 seek=1 conv=notrunc 2>/dev/null

echo "Done! Starting AuroraOS..."
qemu-system-x86_64 -drive format=raw,file=os.img
