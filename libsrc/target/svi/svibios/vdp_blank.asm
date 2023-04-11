;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void vdp_blank();
;
;	Disable screen / Enable screen
;
;	$Id: svi_blank_noblank.asm,v 1.4 2016-06-16 19:30:25 dom Exp $
;
        SECTION code_clib
	PUBLIC	vdp_blank
	PUBLIC	_vdp_blank
	PUBLIC	vdp_noblank
	
        INCLUDE "target/svi/def/svi.def"


vdp_noblank:
_vdp_noblank:

	ld	a,($FE3C+1)	; VDPReg0+1
	or	@01000000
	jr	do_blank

vdp_blank:
_vdp_blank:

	ld	a,($FE3C+1)	; VDPReg0
	and	$bf
	
do_blank:
	ld	($FE3C+1),a	; update VDPReg0	
	
	; Register #1, bit #6 is used to blank screen.
	di
IF VDP_CMD < 0
	ld	(VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
	ld	a,1
IF VDP_CMD < 0
	ld	(VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
	ei

	ret
