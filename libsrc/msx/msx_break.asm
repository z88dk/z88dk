;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_break();
;
;	Checks if the Ctrl-STOP key is being pressed (1 = pressed, 0 = not pressed)
;
;
;	$Id: msx_break.asm,v 1.4 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_break
	EXTERN     msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

msx_break:
	ld	ix,BREAKX
	call	msxbios
	sbc	a,a
	and	1	; if pressed, BREAKX returns $FF
	ld	h,0
	ld	l,a
	ret
