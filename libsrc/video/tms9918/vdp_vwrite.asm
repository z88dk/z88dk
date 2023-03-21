;
;	z88dk library: Generic VDP support code
;
;	extern void vdp_vwrite(void *source, u_int dest, u_int count)
;
;	Transfer count bytes from RAM to VRAM (BIOS paged version)
;
;	$Id: gen_vwrite.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

    SECTION code_video_vdp
    PUBLIC  vdp_vwrite
    PUBLIC  _vdp_vwrite

    EXTERN  LDIRVM

    INCLUDE "video/tms9918/vdp.inc"


vdp_vwrite:
_vdp_vwrite:
    push    ix          ;save callers
    ld      ix,4
    add     ix,sp

    ld      c,(ix+0)    ; count
    ld      b,(ix+1)

    ld      e, (ix+2)   ; dest
    ld      d, (ix+3)

    ld      l, (ix+4)   ; source
    ld      h, (ix+5)

    call    LDIRVM
    pop     ix          ; resotre callers
    ret
	
