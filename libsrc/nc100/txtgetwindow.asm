
                SECTION code_clib
		PUBLIC txtgetwindow
		PUBLIC _txtgetwindow

; fastcall
.txtgetwindow	
._txtgetwindow	
		push	ix	;save callers
		push hl
		call 0xB830
		pop ix
		ld (ix), h
		ld (ix + 1), l
		ld (ix + 2), d
		ld (ix + 3), e
		ld (ix + 4), 0
		jr	c,exit
		ld (ix + 4), 1
.exit		pop	ix	;restore callers
		ret


