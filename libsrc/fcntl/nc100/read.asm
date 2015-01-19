;
;	read from disk
;
		PUBLIC read
.read
		pop ix
		pop de
		pop hl
		pop bc
		push bc
		push hl
		push de
		push ix
		ld a, b
		or c
		call nz, 0xB896
		ld h, b
		ld l, c
		ret

