mov ah, 0x0e
mov al, [secret]
int 0x10

mov bx, 0x7c0 ; CPU multiplies the value in ds by 16 and adds offset (multiplying by 16 means left shift by 1 in hexadecimal)
mov ds, bx
mov al, [secret] ; al = ds * 16 + secret
int 0x10

mov bx, 0x7c0
mov es, bx
mov al, [es:secret] ; use es instead of ds segment register
int 0x10

call print_newline

mov dx, es ; checking
call print_hex

jmp $

%include "boot-functions-print-hex.asm"
%include "boot-functions-print-newline.asm"


secret:
	db "X"

times 510 - ($-$$) db 0
dw 0xaa55