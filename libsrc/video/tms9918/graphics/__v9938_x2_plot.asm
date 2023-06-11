

SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_x2_plot

EXTERN  __tms9918_gfxh
EXTERN  __tms9918_2bpp_attr
EXTERN  __gfx_coords
EXTERN  __v9938_pset

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; in:  de = (x,y) coordinate of pixel (h,l)
;
; Fatpix is permanently engaged

__v9938_x2_plot:
    ex      de,hl

    ; Only range check the height
    ld      a,(__tms9918_gfxh)
    cp      l
    ret     c
    push    bc


    ld      (__gfx_coords),hl
    ld      de,0            ;High coords
    rl      h               ;Multiply x by 2
    rl      d
    ld      a,(__tms9918_2bpp_attr)
    rlca
    rlca
    and     $0f
    ld      b,a
    ld      a,V9938_LOGIC_SET
    push    hl
    push    de
    push    bc
    call    __v9938_pset
    pop     bc
    pop     de
    pop     hl
    inc     h       ;Go to next pixel
    ld      a,V9938_LOGIC_SET
    call    __v9938_pset

    pop     bc
    ret



ENDIF