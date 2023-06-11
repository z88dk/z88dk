;
;	z88dk library: Generic VDP support code
;
;	extern void vread(unsigned int source, void* dest, unsigned int count);
;
;	Transfer count bytes from VRAM to RAM
;

    SECTION code_video_vdp
    PUBLIC  vdp_vread
    PUBLIC  _vdp_vread

    EXTERN  SETRD

    INCLUDE "video/tms9918/vdp.inc"


vdp_vread:
_vdp_vread:
    push    ix          ;save callers ix
    ld      ix,4
    add     ix,sp

    ld      e,(ix+2)    ; dest
    ld      d,  (ix+3)

    ld      l,(ix+4)    ; source
    ld      h,(ix+5)

    call    SETRD
    ex      (sp),hl     ; VDP Timing
    ex      (sp),hl     ; VDP Timing

    ld      l, (ix+0)   ; count
    ld      h, (ix+1)

IF VDP_DATAIN >= 256
    ld      bc,VDP_DATAIN
ENDIF

rdloop:
    VDPIN(VDP_DATAIN)
    ld      (de),a
    inc     de
    dec     hl
    ld      a,h
    or      l
    jr      nz,rdloop
    pop     ix          ;restore callers
    ret

