;boot-read-disk.asm
mov bx, 0x7c0
mov ds, bx

mov ah, 0x02

mov dl, 0 ; drive 0 (0-indexed)
mov ch, 3 ; cylinder 3 (0-indexed)
mov dh, 1 ; track 1 (0-indexed)
mov cl, 4 ; 4th sector (1-indexed)
mov al, 5 ; number of sector = 5 (from start, aks 4th sector)

; read from disk and store in memory location [es:bx]
mov bx,  0xa000
mov es, bx
mov bx, 0x1234 ; this will save the data in location 0xa1234

int 0x13

jc disk_error ; jc will jump if carry flag is set, BIOS will set the carry flag if there's any error while reading disk

cmp al, 5 ; check if number of sectors actually read == 5 or not, BIOS will save the number of sectors read inside al
jne disk_error

disk_success:
	mov bx, DISK_SUCCESS_MSG
	call print_string
	jmp $

disk_error:
	mov bx, DISK_ERROR_MSG
	call print_string

	call print_newline

	mov bx, DISK_NUM_SECTORS_READ_MSG
	call print_string

	mov dx, 0x0000
	mov dl, al
	call print_hex

	jmp $

%include "boot-functions-print-newline.asm"
%include "boot-functions-print-hex.asm"

DISK_SUCCESS_MSG:
	db "Disk read successfully ...", 0

DISK_ERROR_MSG:
	db "Error while reading from disk!", 0

DISK_NUM_SECTORS_READ_MSG:
	db "Number of sectors read: ", 0

times 510 - ($-$$) db 0
dw 0xaa55