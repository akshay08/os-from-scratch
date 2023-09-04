mov bx, 0x7c0
mov ds, bx

mov [BOOT_DRIVE], dl ; BIOS stores our current boot drive in dl, so store it in BOOT_DRIVE variable

mov bp, 0x8000 ; set stack pointer out of the way
mov sp, bp

mov bx, 0x9000 ; Load sectors to ES:BX -> 0x0000:0x9000
mov dl, [BOOT_DRIVE]
mov dh, [NUM_SECTORS]

call disk_load

call print_newline
mov bx, DISK_READ_WORD_MSG
call print_string
mov dx, [es:0x9000]
call print_hex ; read first word of 1st read sector

call print_newline
mov bx, DISK_READ_WORD_MSG
call print_string
mov dx, [es:0x9000+512]
call print_hex ; read first word of 2nd read sector

call print_newline
mov bx, DISK_READ_WORD_MSG
call print_string
mov dx, [es:0x9000+1024]
call print_hex ; read first word of 3rd read sector

call print_newline
mov bx, DISK_READ_WORD_MSG
call print_string
mov dx, [es:0x9000+1024+512]
call print_hex ; read first word of 4th read sector


jmp $

%include "boot-functions-disk-load.asm"
%include "boot-functions-print-string.asm"
%include "boot-functions-print-hex.asm"
%include "boot-functions-print-newline.asm"

BOOT_DRIVE: db 0
NUM_SECTORS: db 5
DISK_READ_WORD_MSG:
	db "Read this from disk: ", 0

times 510 - ($-$$) db 0
dw 0xaa55

; add a few more sectors after the boot sector
times 256 dw 0xdada ; 1 sector (512 bytes)
times 256 dw 0xface ; 1 sector
times 1024 dw 0xbada ; 4 sectors