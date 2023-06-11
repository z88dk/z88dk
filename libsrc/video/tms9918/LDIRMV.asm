;
;	z88dk library: Generic VDP support code
;
;	LDIRMV
;
;
;	$Id: gen_ldirmv.asm$
;

    SECTION code_video_vdp
    PUBLIC  LDIRMV
    PUBLIC  _LDIRMV
    EXTERN  SETRD

    INCLUDE	"video/tms9918/vdp.inc"
	
LDIRMV:
_LDIRMV:
    push    bc
    call    SETRD
    pop     hl	
loop:
    VDPIN(VDP_DATAIN)
    ld      (de),a
    inc     de
    dec     hl
    ld      a,h
    or      l
    jr      nz,loop
    ret
