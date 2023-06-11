;
;	z88dk library: Generic VDP support code
;
;	FILVRM
;
;
;	$Id: gen_ldirvm.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

    SECTION code_video_vdp
    PUBLIC  LDIRVM
    PUBLIC  _LDIRVM
    EXTERN  SETWRT

    INCLUDE	"video/tms9918/vdp.inc"
	
LDIRVM:
_LDIRVM:
    ex      de,hl
    push    bc
    call    SETWRT
    pop     hl
IF VDP_DATA >= 256
    ld      bc,VDP_DATA
ENDIF
loop: 	
    ld      a,(de)
    VDPOUT(VDP_DATA)
    inc     de
    dec     hl
    ld      a,h
    or      l
    jr      nz,loop
    ret
