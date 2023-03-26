; ----- void __CALLEE__ xordrawr(int x2, int y2)

    SECTION code_video_vdp

    PUBLIC  xordrawr_callee
    PUBLIC  _xordrawr_callee
    
    PUBLIC  asm_xordrawr
    

    EXTERN  __v9938_4bpp_xordrawr
    EXTERN  __v9938_8bpp_xordrawr
    EXTERN  __tms9918_screen_mode
    
    EXTERN    Line_r
    EXTERN    xorpixel
    INCLUDE "video/tms9918/vdp.inc"


.xordrawr_callee
._xordrawr_callee    
    pop     af    ; ret addr
    pop     de    ; y
    pop     hl    ; x
    push    af    ; ret addr
    
.asm_xordrawr
IFDEF V9938
    ld      a,(__tms9918_screen_mode)
    cp      5
    jp      z,__v9938_4bpp_xordrawr
    cp      8
    jp      z,__v9938_8bpp_xordrawr
ENDIF
    push    ix
    ld      ix,xorpixel
    call    Line_r
    pop     ix
    ret
