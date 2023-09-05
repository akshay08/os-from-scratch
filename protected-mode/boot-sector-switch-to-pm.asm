[org 0x7c00]

mov bp, 0x9000
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call switch_to_pm ; We never return from here

%include "../boot/boot-functions-print-string.asm"
%include "gdt.asm"
%include "pm-functions-print-string.asm"
%include "switch-to-pm.asm"


[bits 32]

BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm

	jmp $

MSG_REAL_MODE: db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE: db "Successfully landed in 32-bit Protected Mode", 0

times 510 - ($-$$) db 0
dw 0xaa55