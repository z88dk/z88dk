		
                SECTION code_clib
		PUBLIC	editbuf
		PUBLIC	_editbuf

.editbuf
._editbuf
		pop de
		pop hl
		pop bc
		push bc
		push hl
		push de
		ld b, c
		ld c, a
		call 0xB800
		ld hl, 0
		ret c
		dec hl
		ret
