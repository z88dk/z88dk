;
;	Write a file on an Amstrad NC100
;

		SECTION code_clib
		PUBLIC write
		PUBLIC _write

._write
.write		pop af
		pop de
		pop hl
		pop bc
		push bc
		push hl
		push de
		push af
		ld a, b
		or c
		call nz, 0xB8AB
		ld h, b
		ld l, c
		ret
