[org 0x7c00]

mov ah, 0x0e

mov bx, my_string

check:
	mov al, [bx]
	cmp al, 0
	je done
	jmp print

print:
	int 0x10
	inc bx
	jmp check

done:
	jmp $

my_string:
	db 'Booting OS ...'
	db 0x0a ; \n
	db 0x0d ; \r
	db 'Done!', 0 ; null terminating a string to know where it ends

times 510 - ($-$$) db 0

dw 0xaa55