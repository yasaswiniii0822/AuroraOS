[org 0x7c00]
bits 16

start:
    mov si, logo
    call print_string

input_loop:

    mov ah, 0x00
    int 0x16

    mov ah, 0x0e
    int 0x10

    jmp input_loop

print_string:
.next_char:
    lodsb
    cmp al, 0
    je .done

    mov ah, 0x0e
    int 0x10
    jmp .next_char

.done:
    ret


logo db 13,10
     db "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",13,10
     db "                                 <3  AuroraOS  <3",13,10
     db "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",13,10
     db 13,10
     db "  Loading kernel...",13,10
     db "  Starting services...",13,10
     db 13,10
     db "Aurora >",0

times 510-($-$$) db 0
dw 0xaa55