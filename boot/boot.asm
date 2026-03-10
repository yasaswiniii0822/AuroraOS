[org 0x7c00]
bits 16

start:
    mov ah, 0x0e

    mov al, 'A'
    int 0x10
    mov al, 'u'
    int 0x10
    mov al, 'r'
    int 0x10
    mov al, 'o'
    int 0x10
    mov al, 'r'
    int 0x10
    mov al, 'a'
    int 0x10

hang:
    jmp hang

times 510-($-$$) db 0
dw 0xaa55