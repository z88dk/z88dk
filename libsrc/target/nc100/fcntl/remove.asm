		
		SECTION code_clib
		PUBLIC remove
		PUBLIC _remove

.remove
._remove
		call 0xB893
		ld hl, 0
		ret c
		dec hl
		ret
