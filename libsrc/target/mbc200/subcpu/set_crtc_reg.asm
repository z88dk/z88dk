;
;	Sanyo MBC-200 specific routines
;	by Stefano Bodrato, 2023
;
;	Set video control registers
;
;	int  set_crtc_reg(unsigned char register, unsigned char value);
;
;
;	$Id: set_crtc_reg.asm $
;	

	SECTION		code_clib

	PUBLIC	set_crtc_reg
	PUBLIC	_set_crtc_reg

	EXTERN  mbc_sub

set_crtc_reg:
_set_crtc_reg:

	pop	bc
	pop	de
	ld a,e
	ld (vdu_smc2+1),a
	pop	hl
	ld a,l
	ld (vdu_smc1+1),a
	push	hl
	push	de
	push	bc
	ld hl,vdu_code
	ld de,vdu_end-vdu_code
	jp mbc_sub

;-------------------
vdu_code:
vdu_smc1:
	ld	a,0
	out	($B0),a
vdu_smc2:
	ld	a,0
	out	($B1),a
	ret
vdu_end:
