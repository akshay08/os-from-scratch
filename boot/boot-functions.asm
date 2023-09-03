[org 0x7c00]

mov bx, HELLO_MSG
call print_string

mov bx, NEWLINE_MSG
call print_string

mov bx, GOODBYE_MSG
call print_string

jmp done

%include "boot-functions-print-string.asm"

done:
	jmp $

HELLO_MSG:
	db "Hello, world!", 0

NEWLINE_MSG:
	db 0x0a, 0x0d, 0 ; \n\r

GOODBYE_MSG:
	db "Goodbye, world.", 0

times 510 - ($-$$) db 0
dw 0xaa55