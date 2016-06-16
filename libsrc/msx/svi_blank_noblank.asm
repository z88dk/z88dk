;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void msx_blank();
;
;	Disable screen / Enable screen
;
;	$Id: svi_blank_noblank.asm,v 1.4 2016-06-16 19:30:25 dom Exp $
;
        SECTION code_clib
	PUBLIC	msx_blank
	PUBLIC	_msx_blank
	PUBLIC	msx_noblank
	
        INCLUDE "svi.def"


msx_noblank:
_msx_noblank:

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
