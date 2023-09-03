; The BIOS loads the boot sect (aka this file) of size 512 bytes. And stores it in memory (RAM), at location 0x7c00 - 0x7e00 (0x00 - 0x100 represents 256 bytes)

the_secret:
    db "X"

mov ah, 0x0e ;tty mode (ah = 14)

; attempt 1
; Fails because it tries to print the memory address (i.e. pointer)
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
; It tries to print the memory address of 'the_secret' which is the correct approach.
; However, BIOS places our bootsector binary at address 0x7c00
; so we need to add that padding beforehand. We'll do that in attempt 3
mov al, "2"
int 0x10
mov al, [the_secret]
int 0x10

mov al, 0x0a ; newline char \n = 10 (ascii)
int 0x10
mov al, 0x0d ; carriage return char \r = 13 (ascii)
int 0x10

; attempt 3
; Add the BIOS starting offset 0x7c00 to the memory address of the X
; and then dereference the contents of that pointer.
; We need the help of a different register 'bx' because 'mov al, [ax]' is illegal.
; A register can't be used as source and destination for the same command.
mov al, "3"
int 0x10
mov bx, the_secret
add bx, 0x7c00
mov al, [bx]
int 0x10

mov al, 0x0a ; newline char \n = 10 (ascii)
int 0x10
mov al, 0x0d ; carriage return char \r = 13 (ascii)
int 0x10

; attempt 4
; We try a shortcut since we know that the X is stored at byte 0x2d in our binary
; That's smart but ineffective, we don't want to be recounting label offsets
; every time we change the code
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
mov al, "4"
int 0x10
mov al, [0x7c00]
int 0x10

mov al, 0x0a ; newline char \n = 10 (ascii)
int 0x10
mov al, 0x0d ; carriage return char \r = 13 (ascii)
int 0x10

jmp $ ; jump to current location (infinite loop)

; Fill with 510 zeros minus the size of the previous code
times 510-($-$$) db 0
; Magic number
dw 0xaa55 
