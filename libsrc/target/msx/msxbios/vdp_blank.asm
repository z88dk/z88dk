;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void vdp_blank();
;
;	Disable screen
;
;	$Id: vdp_blank.asm,v 1.5 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	vdp_blank
	PUBLIC	_vdp_blank
	EXTERN	msxbios
	
        INCLUDE "target/msx/def/msxbios.def"

vdp_blank:
_vdp_blank:
	push	ix		;save callers
	ld	ix,DISSCR
	call	msxbios
	pop	ix
	ret
