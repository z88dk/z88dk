; ----- void __CALLEE__ undraw(int x, int y, int x2, int y2)


    SECTION code_video_vdp

    PUBLIC  undraw_callee
    PUBLIC  _undraw_callee
    
    PUBLIC  asm_undraw


    EXTERN  __tms9918_screen_mode
    EXTERN  __v9938_4bpp_undraw
    EXTERN  __v9938_8bpp_undraw

    EXTERN  Line
    EXTERN  respixel
    INCLUDE "video/tms9918/vdp.inc"

.undraw_callee
._undraw_callee    
    pop     af    ; ret addr
    pop     de    ; y2
    pop     hl
    ld      d,l    ; x2
    pop     hl    ; y
    pop     bc
    ld      h,c    ; x
    push    af    ; ret addr
    
.asm_undraw
IFDEF V9938
    ld      a,(__tms9918_screen_mode)
    cp      5
    jp      z,__v9938_4bpp_undraw
    cp      8
    jp      z,__v9938_8bpp_undraw
ENDIF
    push    ix
    push    hl
    push    de
    call    respixel
    pop     de
    pop     hl
    ld      ix,respixel
    call    Line
    pop     ix
    ret

