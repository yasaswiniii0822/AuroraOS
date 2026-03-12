[org 0x7C00]
bits 16

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov [BOOT_DRIVE], dl

    mov bx, 0x8000        ; load kernel here
    mov ah, 0x02          ; read sectors
    mov al, 1             ; number of sectors
    mov ch, 0             ; cylinder
    mov cl, 2             ; sector 2
    mov dh, 0             ; head
    mov dl, [BOOT_DRIVE]
    int 13h

    jc disk_error

    jmp 0x0000:0x8000     ; jump to kernel

disk_error:
    mov si, msg
.print:
    lodsb
    cmp al,0
    je $
    mov ah,0x0e
    int 10h
    jmp .print

msg db "Disk read error",0

BOOT_DRIVE db 0

times 510-($-$$) db 0
dw 0xAA55