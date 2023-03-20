;
;	z88dk library: Generic VDP support code
;
;	extern void vdp_vfill(unsigned int addr, unsigned char value, unsigned int count);
;
;	Fills a VRAM portion with the given value
;
;	$Id: gen_vfill.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;


    SECTION code_video_vdp
    PUBLIC	vdp_vfill
    PUBLIC	_vdp_vfill

    EXTERN     FILVRM


    INCLUDE	"video/tms9918/vdp.inc"


vdp_vfill:
_vdp_vfill:
    push    ix
    ld      ix,4
    add     ix,sp
    ld c,   (ix+0)	; count
    ld b,   (ix+1)
    ld a,   (ix+2)	; value
    ld l,   (ix+4)	; addr
    ld h,   (ix+5)
    call    FILVRM
    pop     ix
    ret
