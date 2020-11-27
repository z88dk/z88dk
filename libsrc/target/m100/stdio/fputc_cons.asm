;
;       TRS 80 Model 100 C Library
;
;	Print character to the screen
;
;	Stefano Bodrato - Feb 2020
;	Alexei Gordeev - Nov 2020
;
;	$Id: fputc_cons.asm$
;
;	Prints at cooards from 4020-4021

	SECTION code_clib
	PUBLIC  fputc_cons_native
	PUBLIC  _fputc_cons_native
	
	INCLUDE "target/m100/def/romcalls.def"
	
fputc_cons_native:
_fputc_cons_native:
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
;	cp	12
;	jr	z,cls
IF STANDARDESCAPECHARS
	; if slash-n encountered, print slash-r slash-n through ROM call
	cp	10  ; LF (n)?
	jr	z, isLF
ENDIF
	; if building for OPTROM, rst 6 is shortcut for "call system ROM by address"
	ROMCALL
	defw CHROUT
	ret
IF STANDARDESCAPECHARS
isLF:
	ROMCALL
	defw CHROUT
	ld	a,13
	ROMCALL
	defw CHROUT
	ret
ENDIF
