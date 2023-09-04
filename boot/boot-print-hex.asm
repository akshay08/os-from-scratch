[org 0x7c00]

mov dx , 0x13be ; store the hex value to print in dx (16-bit)
call print_hex
jmp $ ; loop

%include "boot-functions-print-hex.asm"
%include "boot-functions-print-string.asm"

times 510 - ($-$$) db 0
dw 0xaa55