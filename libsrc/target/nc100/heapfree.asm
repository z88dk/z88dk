		
                SECTION code_clib
		PUBLIC	heapfree
		PUBLIC	_heapfree

; fastcall
.heapfree
._heapfree
		ex de, hl
		jp 0xb884

