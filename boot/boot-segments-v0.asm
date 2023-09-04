[org 0x7c00]

mov dx, cs
call print_hex
call print_newline

mov dx, ds
call print_hex
call print_newline

mov dx, ss
call print_hex
call print_newline

mov dx, es
call print_hex
call print_newline

jmp $

%include "boot-functions-print-hex.asm"
%include "boot-functions-print-newline.asm"

times 510 - ($-$$) db 0

dw 0xaa55