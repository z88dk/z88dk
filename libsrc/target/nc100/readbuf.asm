
                SECTION code_clib
		PUBLIC	readbuf
		PUBLIC	_readbuf

.readbuf
._readbuf
		pop de
		pop hl
		pop bc
		push bc
		push hl
		push de
		ld b, c
		ld c, a
		ld (hl), 0
		call 0xB812
		ld hl, 0
		ret c
		dec hl
		ret
