; ----- void __CALLEE__ draw(int x, int y, int x2, int y2)


    SECTION code_video_vdp

    PUBLIC  draw_callee
    PUBLIC  _draw_callee
    
    PUBLIC  asm_draw


    EXTERN  __tms9918_screen_mode
    EXTERN  __v9938_4bpp_draw
    EXTERN  __v9938_8bpp_draw

    EXTERN  Line
    EXTERN  plotpixel
    INCLUDE "video/tms9918/vdp.inc"

.draw_callee
._draw_callee    
    pop     af    ; ret addr
    pop     de    ; y2
    pop     hl
    ld      d,l    ; x2
    pop     hl    ; y
    pop     bc
    ld      h,c    ; x
    push    af    ; ret addr
    
.asm_draw

IFDEF V9938
    ld      a,(__tms9918_screen_mode)
    cp      5
    jp      z,__v9938_4bpp_draw
    cp      8
    jp      z,__v9938_8bpp_draw
ENDIF
    push    ix
    push    hl
    push    de
    call    plotpixel
    pop     de
    pop     hl
    ld      ix,plotpixel
    call    Line
    pop     ix
    ret

