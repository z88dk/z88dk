;
;	Write a file on an Amstrad NC100
;
		PUBLIC write

.write		pop ix
		pop de
		pop hl
		pop bc
		push bc
		push hl
		push de
		push ix
		ld a, b
		or c
		call nz, 0xB8AB
		ld h, b
		ld l, c
		ret
