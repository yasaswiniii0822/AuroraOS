            [org 0x7c00]
            bits 16

            start:
                xor ax,ax
                mov ds,ax
                mov es,ax

                call border
                mov si,title
                call print
                call border

                mov si,prompt
                call print


            main:
                mov ah,0
                int 16h              ; wait for key

                cmp al,13            ; ENTER
                je run

                cmp al,8             ; ignore backspace for now
                je main

                mov bl,[idx]
                cmp bl,31            ; prevent overflow
                jae main

                mov si,buffer
                xor cx,cx
                mov cl,[idx]
                add si,cx
                mov [si],al

                inc byte [idx]

                mov ah,0x0e          ; echo character
                int 10h

                jmp main


            run:
                mov si,buffer
                xor cx,cx
                mov cl,[idx]
                add si,cx
                mov byte [si],0      ; terminate string

                mov si,buffer
                mov di,cmd_help
                call strcmp
                cmp ax,1
                je help

                mov si,unknown
                call print
                jmp reset


            help:
                call border
                mov si,helpmsg
                call print
                call border


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


            border:
                mov cx,30
                mov al,'~'
            .loop:
                mov ah,0x0e
                int 10h
                loop .loop
                mov si,newline
                call print
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


            title db "  <3 AuroraOS <3",13,10,0
            prompt db "Aurora > ",0
            cmd_help db "help",0

            unknown db 13,10,"Unknown command",13,10,0
            helpmsg db 13,10,"help about clear",13,10,0

            newline db 13,10,0

            buffer times 32 db 0
            idx db 0


            times 510-($-$$) db 0
            dw 0xaa55