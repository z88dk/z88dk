		PUBLIC	heaprealloc

.heaprealloc
		pop hl
		pop de
		pop bc
		push bc
		push de
		push hl
		jp heaprealloc



