;
;	read from disk
;

		SECTION code_clib
		PUBLIC read
		PUBLIC _read
.read
._read
		pop af
		pop de
		pop hl
		pop bc
		push bc
		push hl
		push de
		push af
		ld a, b
		or c
		call nz, 0xB896
		ld h, b
		ld l, c
		ret

