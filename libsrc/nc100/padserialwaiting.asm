		PUBLIC	padserialwaiting

.padserialwaiting
		call 0xb86F
		ld hl, 1
		ret c
		dec hl
		ret
