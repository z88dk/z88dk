                SECTION code_clib	
		PUBLIC	heaprealloc
		PUBLIC	_heaprealloc

.heaprealloc
._heaprealloc
		pop hl
		pop de
		pop bc
		push bc
		push de
		push hl
		jp heaprealloc



