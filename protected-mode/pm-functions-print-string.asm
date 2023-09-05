[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

print_string_pm: ; prints string staring at ebx
	pusha

	mov edx, VIDEO_MEMORY ; keep start of video memory at edx

	print_string_pm_loop:
		mov al, [ebx] ; one byte for ascii
		mov ah, WHITE_ON_BLACK ; other byte for text color and background
		
		cmp al, 0
		je print_string_pm_done ; break on null character

		mov [edx], ax ; write (2 bytes) to video memory at edx

		inc ebx ; increment ebx by 1 to go to next character of string
		add edx, 2 ; increment edx by 2 to go to next character space in video memory (each character takes two bytes -> ascii + text & bg color)

		jmp print_string_pm_loop


	print_string_pm_done:
		popa
		ret