;
;	z88dk library: Generic VDP support code
;
;	extern void vdp_vwrite_direct(void *source, u_int dest, u_int count)
;
;	Transfer count bytes from RAM (current memory page) to VRAM
;
;	$Id: gen_vwrite_direct.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

    SECTION code_video_vdp
    PUBLIC  vdp_vwrite_direct
    PUBLIC  _vdp_vwrite_direct

    EXTERN  SETWRT

    INCLUDE "video/tms9918/vdp.inc"


vdp_vwrite_direct:
_vdp_vwrite_direct:
    push	ix		;save callers
    ld      ix,4
    add     ix,sp

    ld      l, (ix+2)	; dest
    ld      h, (ix+3)

    call    SETWRT

    ld      l, (ix+0)	; count
    ld      h, (ix+1)

    ld      e, (ix+4)	; source
    ld      d, (ix+5)

IF VDP_DATA >= 256
    ld      bc,VDP_DATA
ENDIF

wrtloop:
    ld      a,(de)
    VDPOUT(VDP_DATA)
    inc     de
    dec     hl
    ld      a,h
    or      l
    jr      nz,wrtloop
    pop     ix		;restore callers
    ret

