;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void vdp_noblank();
;
;	Enable screen
;
;	$Id: vdp_noblank.asm,v 1.5 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	vdp_noblank
	PUBLIC	_vdp_noblank
	EXTERN	msxbios
	
        INCLUDE "target/msx/def/msxbios.def"

vdp_noblank:
_vdp_noblank:
	push	ix
	ld	ix,ENASCR
	call	msxbios
	pop	ix
	ret
