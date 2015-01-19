;
;	z88dk library: Generic VDP support code
;
;	void get_vdp_reg(int reg)
;
;==============================================================
;	Gets the value of a VDP register
;==============================================================
;
;	$Id: gen_get_vdp_reg.asm,v 1.2 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	get_vdp_reg
	EXTERN	RG0SAV


get_vdp_reg:
	
	;;return *(u_char*)(RG0SAV + reg);
	
	; (FASTCALL) -> HL = address

	ld	de,RG0SAV
	add	hl,de
	
	ld	a,(hl)
	
	ld	h,0
	ld	l,a
	ret
