		
		SECTION code_clib
		PUBLIC rename
		PUBLIC _rename

.rename
._rename
		pop bc
		pop hl
		pop de
		push de
		push hl
		push bc
		call 0xB8B1
		ld hl, 0
		ret c
		dec hl
		ret
