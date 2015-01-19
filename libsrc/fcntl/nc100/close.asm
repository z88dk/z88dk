;
;	Close a file handle
;
		PUBLIC close

.close		pop hl
		pop de
		push de
		push hl
		call 0xB890
		ld hl, 0
		ret c
		dec hl
		ret
