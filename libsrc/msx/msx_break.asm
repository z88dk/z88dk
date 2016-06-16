;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_break();
;
;	Checks if the Ctrl-STOP key is being pressed (1 = pressed, 0 = not pressed)
;
;
;	$Id: msx_break.asm,v 1.5 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_break
	PUBLIC	_msx_break
	EXTERN     msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

msx_break:
_msx_break:
	push	ix
	ld	ix,BREAKX
	call	msxbios
	sbc	a,a
	and	1	; if pressed, BREAKX returns $FF
	ld	l,a
	ld	h,0
	pop	ix
	ret
