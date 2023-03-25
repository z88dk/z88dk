

SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_plot

EXTERN  __tms9918_gfxh
EXTERN  __tms9918_attribute
EXTERN  __v9938_pset

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; in:  de = (x,y) coordinate of pixel (h,l)

__v9938_plot:
    ex      de,hl

    ; Only range check the height
    ld      a,(__tms9918_gfxh)
    cp      l
    ret     c

    push    bc
    ld      a,(__tms9918_attribute)
    rrca
    rrca
    rrca
    rrca
    and     $0f
    ld      e,a
    ld      a,V9938_LOGIC_SET
    call    __v9938_pset
    pop     bc
    ret


ENDIF