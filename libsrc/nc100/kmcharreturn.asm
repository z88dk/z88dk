                SECTION code_clib	
		PUBLIC	kmcharreturn
		PUBLIC	_kmcharreturn

.kmcharreturn
._kmcharreturn
		pop af
		pop bc
		push	bc
		push	af
		call 0xB803
		ret

