;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	void vdp_vpoke(int address, int value);
;
;	Improved functions by Rafael de Oliveira Jannone
;	Originally released in 2004 for GFX - a small graphics library
;
;	$Id: vdp_vpoke.asm$
;

    SECTION code_video_vdp
    PUBLIC	vpoke
    PUBLIC	_vpoke
    PUBLIC	vdp_vpoke
    PUBLIC	_vdp_vpoke

    EXTERN asm_vdp_vpoke


vpoke:
_vpoke:
vdp_vpoke:
_vdp_vpoke:

    pop	bc
    pop	de
    pop	hl
    push	hl	; VRAM address
    push	de	; value
    push	bc	; RET address

    jp asm_vdp_vpoke

