
	SECTION	code_clib
	PUBLIC	getmaxy
	PUBLIC	_getmaxy

	EXTERN	__console_h


getmaxy:
_getmaxy:
IF __CPU_GBZ80__
	ld	hl,__console_h
	ld	l,(hl)
ELSE
	ld	hl,(__console_h)
ENDIF
	ld	h,0
	dec	hl
	dec	hl
	ret
