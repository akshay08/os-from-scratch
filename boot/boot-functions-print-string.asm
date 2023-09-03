print_string: ; prints string starting at [bx] and ending in NULL character
	pusha

	check:
		mov al, [bx]
		cmp al, 0
		je print_string_done

		mov ah, 0x0e
		int 0x10
		inc bx
		jmp check

	print_string_done:
		popa
		ret