; ----- void __CALLEE__ xordraw(int x, int y, int x2, int y2)


    SECTION code_video_vdp

    PUBLIC  xordraw_callee
    PUBLIC  _xordraw_callee
    
    PUBLIC  asm_xordraw


    EXTERN  __tms9918_screen_mode
    EXTERN  __v9938_4bpp_xordraw
    EXTERN  __v9938_8bpp_xordraw

    EXTERN  Line
    EXTERN  xorpixel
    INCLUDE "video/tms9918/vdp.inc"

.xordraw_callee
._xordraw_callee    
    pop     af    ; ret addr
    pop     de    ; y2
    pop     hl
    ld      d,l    ; x2
    pop     hl    ; y
    pop     bc
    ld      h,c    ; x
    push    af    ; ret addr
    
.asm_xordraw
IFDEF V9938
    ld      a,(__tms9918_screen_mode)
    cp      5
    jp      z,__v9938_4bpp_xordraw
    cp      8
    jp      z,__v9938_8bpp_xordraw
ENDIF
    push    ix
    push    hl
    push    de
    call    xorpixel
    pop     de
    pop     hl
    ld      ix,xorpixel
    call    Line
    pop     ix
    ret

