;
;	z88dk library: Generic VDP support code
;
;	void get_vdp_reg(int reg)
;
;==============================================================
;	Gets the value of a VDP register
;==============================================================
;
;	$Id: gen_get_vdp_reg.asm,v 1.1 2010-06-30 13:21:38 stefano Exp $
;

	XLIB	get_vdp_reg
	XREF	RG0SAV


get_vdp_reg:
	
	;;return *(u_char*)(RG0SAV + reg);
	
	; (FASTCALL) -> HL = address

	ld	de,RG0SAV
	add	hl,de
	
	ld	a,(hl)
	
	ld	h,0
	ld	l,a
	ret
