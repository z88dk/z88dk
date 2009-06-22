;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_break();
;
;	Checks if the Ctrl-STOP key is being pressed (1 = pressed, 0 = not pressed)
;
;
;	$Id: msx_break.asm,v 1.3 2009-06-22 21:44:17 dom Exp $
;

	XLIB	msx_break
	LIB     msxbios
	
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
