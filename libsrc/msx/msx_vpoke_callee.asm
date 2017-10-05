;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	void msx_vpoke(int address, int value);
;
;	Improved functions by Rafael de Oliveira Jannone
;	Originally released in 2004 for GFX - a small graphics library
;
;	$Id: msx_vpoke_callee.asm$
;

        SECTION code_clib
	PUBLIC	msx_vpoke_callee
	PUBLIC	_msx_vpoke_callee
	
	PUBLIC	msx_vpoke_direct

	PUBLIC ASMDISP_MSX_VPOKE_CALLEE
	
	EXTERN	msxbios

	
	INCLUDE	"msx/vdp.inc"


msx_vpoke_callee:
_msx_vpoke_callee:

	pop	bc
	pop	de	; value
	pop	hl	; VRAM address
	push	bc
	
.asmentry
	ld	a,e
msx_vpoke_direct:
	;ld	ix,WRTVRM
	;jp	msxbios

	; enter vdp address pointer
	push	af
	ld	a,l
	di
	out	(VDP_CMD), a
	ld	a,h
	and	@00111111
	or 	@01000000
	ei
	out	(VDP_CMD), a

	; enter data
	pop 	af			; "ld a,e" could be too fast, better to keep the POP instruction
	out	(VDP_DATA), a

	ret
	
DEFC ASMDISP_MSX_VPOKE_CALLEE = # asmentry - msx_vpoke_callee
