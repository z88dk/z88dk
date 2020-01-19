
	SECTION	code_clib
	PUBLIC	getmaxx
	PUBLIC	_getmaxx

	EXTERN	__console_w


getmaxx:
_getmaxx:
IF __CPU_GBZ80__
	ld	hl,__console_w
	ld	l,(hl)
ELSE
	ld	hl,(__console_w)
ENDIF
	ld	h,0
	dec	hl
	ret
