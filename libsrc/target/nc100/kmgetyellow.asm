                SECTION code_clib	
		PUBLIC	kmgetyellow
		PUBLIC	_kmgetyellow

.kmgetyellow
._kmgetyellow
		call 0xb8d2
		ld h, b
		ld l, c
		ret




