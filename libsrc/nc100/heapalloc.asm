                SECTION code_clib	
		PUBLIC	heapalloc
		PUBLIC	_heapalloc

; fastcall
.heapalloc
._heapalloc
		ex de, hl
		jp 0xb881

