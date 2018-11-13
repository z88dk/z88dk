		
                SECTION code_clib
		PUBLIC	padserialwaiting
		PUBLIC	_padserialwaiting

.padserialwaiting
._padserialwaiting
		call 0xb86F
		ld hl, 1
		ret c
		dec hl
		ret
