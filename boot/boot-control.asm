; convert to asm
;mov bx , 30
;if ( bx <= 4 ) {
;	mov al, 'A'
;} else if (bx < 40) {
;	mov al, 'B'
;} else {
;	mov al, 'C'
;}
;print(al)
;loop

[org 0x7c00]

mov bx, 100

cmp bx, 4
jle move_A

cmp bx, 40
jl move_B

jmp move_C

move_A:
	mov al, 'A'
	jmp done
move_B:
	mov al, 'B'
	jmp done
move_C:
	mov al, 'C'
	jmp done

done:
	mov ah, 0x0e ; tty mode
	int 0x10 ; print al
	jmp $ ; loop forever

times 510 - ($-$$) db 0 ; pad with zeroes
dw 0xaa55 ; indicate boot sector