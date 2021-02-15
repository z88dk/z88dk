;
;	NEC PC8801 Library
;	by Stefano Bodrato - 2018
;
;	int pc88_break();
;
;	Checks if the Ctrl-STOP key is being pressed (1 = pressed, 0 = not pressed)
;
;
;	$Id: pc88_break.asm $
;

        SECTION code_clib
	PUBLIC	pc88_break
	PUBLIC	_pc88_break
	
	EXTERN	pc88bios
	EXTERN	__brksave

	
        INCLUDE "target/pc88/def/n88bios.def"

pc88_break:
_pc88_break:
	ld	a,(__brksave)
	dec	a
	ret z
	push	ix
	ld	ix,BREAKX
	call pc88bios
	sbc	a,a
	and	1	; if pressed, BREAKX returns 1
	ld	l,a
	ld	h,0
	pop	ix
	ret
