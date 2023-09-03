; The BIOS loads the boot sect (aka this file) of size 512 bytes. And stores it in memory (RAM), at location 0x7c00 - 0x7e00 (0x00 - 0x100 represents 256 bytes)
[org 0x7c00] ; adding this directive means the assembler would add the 0x7c00 offset to all the labels of this code

mov ah, 0x0e ;tty mode (ah = 14)


; attempt 1
; Still fails because it tries to print the memory address (i.e. pointer)
; not its actual contents
mov al, "1"
int 0x10
mov al, the_secret
int 0x10

mov al, 0x0a ; newline char \n = 10 (ascii)
int 0x10
mov al, 0x0d ; carriage return char \r = 13 (ascii)
int 0x10

; attempt 2
; This works now, because the_secret label has now 0x7c00 offset added to it by assembler
mov al, "2"
int 0x10
mov al, [the_secret]
int 0x10

mov al, 0x0a ; newline char \n = 10 (ascii)
int 0x10
mov al, 0x0d ; carriage return char \r = 13 (ascii)
int 0x10

; attempt 3
; This doesn't work anymore, because the 0x7c00 offset is being added twice, once by the assembler and once by us manually below
mov al, "3"
int 0x10
mov bx, the_secret
add bx, 0x7c00
;mov al, [bx]
;int 0x10

mov al, 0x0a ; newline char \n = 10 (ascii)
int 0x10
mov al, 0x0d ; carriage return char \r = 13 (ascii)
int 0x10

; attempt 4
; Still doesn't work because our X is defined in a different location than the book
mov al, "4"
int 0x10
mov al, [0x7c2d] ; this doesn't work because the location of X in our binary is different from 0x2d, as we have put X at the very top
int 0x10

mov al, 0x0a ; newline char \n = 10 (ascii)
int 0x10
mov al, 0x0d ; carriage return char \r = 13 (ascii)
int 0x10


; attempt 4b
; Use location of X = 0x00
; Doesn't work now because we've change the location of X yet again
mov al, "4"
int 0x10
;mov al, [0x7c20]
;int 0x10

mov al, 0x0a ; newline char \n = 10 (ascii)
int 0x10
mov al, 0x0d ; carriage return char \r = 13 (ascii)
int 0x10

jmp $ ; jump to current location (infinite loop)

the_secret:
    db "X"


; Fill with 510 zeros minus the size of the previous code
times 510-($-$$) db 0
; Magic number
dw 0xaa55 
