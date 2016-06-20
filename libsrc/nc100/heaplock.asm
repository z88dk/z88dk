                SECTION code_clib	
		PUBLIC	heaplock
		PUBLIC	_heaplock

.heaplock
._heaplock
		pop hl
		pop de
		pop bc
		push bc
		push de
		push hl
		call 0xb884
		ld h, b
		ld l, c
		ret



