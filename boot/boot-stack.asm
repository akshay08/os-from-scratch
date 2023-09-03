[org 0x7c00]
mov ah, 0x0e ; tty (tele-type) mode

mov bp, 0x8000 ; base pointer (of stack)
mov sp, bp ; stack pointer

push 'A' ; 16-bit mode, so 0'A' will be pushed onto the stack, aka NULL pointer and character 'A'

pop bx ; pop the stack (0'A') and push it to 16-bit register bx
mov al, bl ; copy the lower 8 bits (aka bl) from bx onto al, for printing
int 0x10 ; print contents of al onto screen

push 'B'
push 'C'
push 'DE'

pop bx ; pop 'DE'
mov al, bh ; print upper 8 bits (aka 'E' character)
int 0x10

mov al, bl  ; print lower 8 bits (aka 'D' character)
int 0x10

pop bx ; pop 0'C'
mov al, bl
int 0x10

pop bx ; pop 0'B'
mov al, bl
int 0x10

jmp $ ; jump forever to current location

times 510 - ($-$$) db 0

dw 0xaa55