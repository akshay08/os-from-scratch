; load DH sectors to ES:BX from drive DL

disk_load:
	pusha
	push dx

	mov al, dh ; number of secotrs = dh

	mov ah, 0x02 ; BIOS read sector routine
	mov ch, 0x00 ; cylinder 0
	mov dh, 0x00 ; track 0 (head 0)
	mov cl, 0x02 ; starting sector 2 (because 1st sector is boot sector)

	int 0x13
	
	pop dx
	
	jc disk_error

	cmp al, dh ; if number of sectors actually read != dh, then throw error
	jne disk_error

	disk_success:
		mov bx, DISK_SUCCESS_MSG
		call print_string
		jmp print_num_sectors_read		

	disk_error:
		mov bx, DISK_ERROR_MSG
		call print_string
		jmp print_num_sectors_read

	print_num_sectors_read:
		call print_newline

		mov bx, DISK_NUM_SECTORS_READ_MSG
		call print_string

		mov dx, 0x0000
		mov dl, al
		call print_hex
		
	popa
	ret


DISK_SUCCESS_MSG:
	db "Disk read successfully!", 0

DISK_ERROR_MSG:
	db "Failed to read from disk!", 0

DISK_NUM_SECTORS_READ_MSG:
	db "Number of sectors read: ", 0