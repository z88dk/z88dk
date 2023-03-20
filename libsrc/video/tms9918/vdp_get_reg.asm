;
;	z88dk library: Generic VDP support code
;
;	void vdp_get_reg(int reg)
;
;==============================================================
;	Gets the value of a VDP register
;==============================================================
;
;	$Id: gen_vdp_get_reg.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

    SECTION code_video_vdp
    PUBLIC  vdp_get_reg
    PUBLIC  _vdp_get_reg
    EXTERN  RG0SAV


vdp_get_reg:
_vdp_get_reg:

    ;;return *(u_char*)(RG0SAV + reg);

    ; (FASTCALL) -> HL = address

    ld      de,RG0SAV
    add     hl,de
    ld      l,(hl)
    ld      h,0
    ret
