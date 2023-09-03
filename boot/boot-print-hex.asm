[org 0x7c00]

mov dx , 0x1fb6 ; store the hex value to print in dx (16-bit)
call print_hex
jmp $ ; loop

print_hex:
	pusha
	; set HEX_STRING from dx register
	mov ax, 0 ; for counting hex digits
	set_hex_string:
		mov cl, dl ; copy dl into cl
		and cl, 0x0f ; get last 4 bits of cl (all other to 0)
		cmp cl, 10 ; if cl < 10, print numeric (0-9) else print alphabet (a-f)
		jl set_numeric ; 0-9
		jmp set_alphabet ; a-f
		
		set_numeric:
			add cl, 48; in ascii 0 = 48
			jmp set_hex_digit
		set_alphabet:
			add cl, (65-10); in ascii A = 65 (but value of a is 10, so subtract 10)
			jmp set_hex_digit

		set_hex_digit:
			mov bx, HEX_STRING+5; location of (least significant) hex_digit in HEX_STRING
			sub bx, ax ; location of current (ax'th) hex digit (ax = 0 least significant, ax=3 most significant)
			mov [bx], cl

			shr dx, 4 ; right shift dx by 4 bits (aka 1 hex digit), which we have already stored
			inc ax; increment number of hex digits by 1
			cmp dx, 0; if dx is 0 then all hex digits are saved in HEX_STRING
			je done_set_hex_string
			jmp set_hex_string

	done_set_hex_string:
		mov bx, HEX_STRING
		call print_string ; from [bx]
		popa
		ret

	HEX_STRING:
		db "0x0000", 0 ; init HEX_STRING by zeroes


%include "boot-functions-print-string.asm"

times 510 - ($-$$) db 0
dw 0xaa55