;
;	z88dk library: Generic VDP support code
;
;	void vdp_set_reg(int reg, int value)
;
;==============================================================
;	Sets the value of a VDP register
;==============================================================
;
;	$Id: gen_vdp_set_reg.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

    SECTION code_video_vdp
    PUBLIC	vdp_set_reg
    PUBLIC	_vdp_set_reg
    EXTERN  VDPreg_Write


    INCLUDE	"video/tms9918/vdp.inc"


.vdp_set_reg
._vdp_set_reg
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)     ; Value
    inc     hl
    inc     hl
    ld      e,(hl)      ;Register
    jp      VDPreg_Write