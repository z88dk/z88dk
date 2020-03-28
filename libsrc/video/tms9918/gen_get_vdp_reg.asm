;
;	z88dk library: Generic VDP support code
;
;	void get_vdp_reg(int reg)
;
;==============================================================
;	Gets the value of a VDP register
;==============================================================
;
;	$Id: gen_get_vdp_reg.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	get_vdp_reg
	PUBLIC	_get_vdp_reg
	EXTERN	RG0SAV


get_vdp_reg:
_get_vdp_reg:
	
	;;return *(u_char*)(RG0SAV + reg);
	
	; (FASTCALL) -> HL = address

	ld	de,RG0SAV
	add	hl,de
	ld	l,(hl)
	ld	h,0
	ret
