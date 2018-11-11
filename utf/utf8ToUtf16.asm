.686
.model flat
extern _ExitProcess@4:PROC
extern _MessageBoxW@16 : PROC
public _main

.data
tytul	dw 'T', 'y','t','u','l',0
bufor	db 50h, 6fh, 0c5h, 82h, 0c4h, 85h, 63h, 7ah
		db 65h, 6eh, 69h, 65h, 20h, 7ah, 6fh, 73h
		db 74h, 61h, 0c5h, 82h, 6fh, 20h, 6eh, 61h
		db 77h, 69h, 0c4h, 85h, 7ah, 61h, 6eh, 65h
		db 2eh, 0e2h, 91h, 0a4h
result	db 74 dup (?)
.code
_main PROC
	mov ecx, 36
	mov esi, offset bufor
	mov edi, offset result
processing:
	mov bx, 0
	mov al, [esi]
	rcl al, 1	; czy 1-bajtowa liczba
	jc multibyte_character
ascii_character:
	rcr al, 1
	mov bl, al
	add esi, 1
	dec ecx
	jmp ready
multibyte_character:
	rcr al, 2
	jc tribytes_character
	rcr al, 3
	and  al, 00011111B
	or bl, al
	add esi, 2
	sub ecx, 2
	jmp ready
tribytes_character:	;zaczynam od srodkowego bajtu
	rcr al, 3
	mov al, [esi+2]
	and al, 00111111B
	shl al, 4
	or bh, al
	mov al, [esi+2]
	and al, 00111111b
	or bh, al
	add esi, 3
	sub ecx, 3
	jmp ready
ready:
	mov [edi], bx
	add edi, 2
	or ecx, ecx
	jnz processing
	nop
	push 0
	push offset tytul
	push offset result
	push 0
	call _MessageBoxW@16
	edd esp, 16

	push 0
	call _ExitProcess@4

_main ENDP
END