SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_undrawr

EXTERN  __tms9918_attribute
EXTERN  __v9938_draw_line
EXTERN  __gfx_coords



; gfx_coords+1 = current x
; Entry:  de = y, hl =x (direction)
__v9938_undrawr:
    ld      a,(__gfx_coords)        ;current y
    ld      c,a
    add     e
    ld      e,a
    ld      a,(__gfx_coords+1)
    ld      h,a
    add     l
    ld      d,a
    ld      l,c

    ld      a,(__tms9918_attribute)
    and     15
    ld      b,a
    ld      a,V9938_LOGIC_SET

    ; draw LINE (H,L)-(D,E) with color B, log-op A
    jp      __v9938_draw_line
    
ENDIF
