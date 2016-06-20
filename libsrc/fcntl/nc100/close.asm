;
;	Close a file handle
;

		SECTION code_clib
		PUBLIC close
		PUBLIC _close

.close		
._close
		pop hl
		pop de
		push de
		push hl
		call 0xB890
		ld hl, 0
		ret c
		dec hl
		ret
