;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void msx_blank();
;
;	Disable screen / Enable screen
;
;	$Id: svi_blank_noblank.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

	XLIB	msx_blank
	XDEF	msx_noblank
	
        INCLUDE "svi.def"


msx_noblank:

	ld	a,($FE3C+1)	; VDPReg0+1
	or	@01000000
	jr	do_blank

msx_blank:

	ld	a,($FE3C+1)	; VDPReg0
	and	$bf
	
do_blank:
	ld	($FE3C+1),a	; update VDPReg0	
	
	; Register #1, bit #6 is used to blank screen.
	di
	out	(VDP_CMD),a
	ld	a,1
	out	(VDP_CMD),a
	ei

	ret
