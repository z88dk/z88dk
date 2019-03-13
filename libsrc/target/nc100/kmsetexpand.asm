		
                SECTION code_clib
		PUBLIC	kmsetexpand
		PUBLIC	_kmsetexpand

.kmsetexpand
._kmsetexpand
		pop de
		pop bc
		pop hl
		push hl
		push bc
		push de
		call 0xB806
		ld hl, 0
		ret c
		dec hl
		ret



