[org 0x8000]
bits 16

start:
    xor ax, ax
    mov ds, ax

    ; force text mode
    mov ax, 0x0003
    int 0x10

    mov si, title
    call print

    mov si, prompt
    call print


main:
    mov ah,0
    int 16h

    cmp al,13
    je run

    cmp al,8
    je backspace

    mov bl,[idx]
    cmp bl,31
    jae main

    mov si,buffer
    xor cx,cx
    mov cl,[idx]
    add si,cx
    mov [si],al

    inc byte [idx]

    mov ah,0x0e
    int 10h

    jmp main


backspace:
    cmp byte [idx],0
    je main

    dec byte [idx]

    mov ah,0x0e
    mov al,8
    int 10h
    mov al,' '
    int 10h
    mov al,8
    int 10h

    jmp main


run:
    mov si,buffer
    xor cx,cx
    mov cl,[idx]
    add si,cx
    mov byte [si],0


    mov si,buffer
    mov di,cmd_help
    call strcmp
    cmp ax,1
    je help


    mov si,buffer
    mov di,cmd_about
    call strcmp
    cmp ax,1
    je about


    mov si,buffer
    mov di,cmd_clear
    call strcmp
    cmp ax,1
    je clear_screen


    mov si,unknown
    call print
    jmp reset


help:
    mov si,helpmsg
    call print
    jmp reset


about:
    mov si,aboutmsg
    call print
    jmp reset


clear_screen:
    mov ax,0x0003
    int 10h
    jmp reset


reset:
    mov byte [idx],0

    mov si,newline
    call print

    mov si,prompt
    call print

    jmp main


print:
.next:
    lodsb
    cmp al,0
    je .done
    mov ah,0x0e
    int 10h
    jmp .next
.done:
    ret


strcmp:
.loop:
    mov al,[si]
    mov bl,[di]
    cmp al,bl
    jne .no
    cmp al,0
    je .yes
    inc si
    inc di
    jmp .loop

.yes:
    mov ax,1
    ret

.no:
    xor ax,ax
    ret


title db 13,10,"AuroraOS Kernel",13,10,0
prompt db "Aurora > ",0

cmd_help db "help",0
cmd_about db "about",0
cmd_clear db "clear",0

helpmsg db 13,10,"Commands: help about clear",13,10,0
aboutmsg db 13,10,"AuroraOS v0.1",13,10,"Created by Yasaswini",13,10,0
unknown db 13,10,"Unknown command",13,10,0

newline db 13,10,0

buffer times 32 db 0
idx db 0