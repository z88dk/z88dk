; ----- void __CALLEE__ undrawr_callee(int x2, int y2)


    SECTION code_video_vdp

    PUBLIC  undrawr_callee
    PUBLIC  _undrawr_callee
    PUBLIC  asm_undrawr


    EXTERN  __v9938_4bpp_undrawr
    EXTERN  __v9938_8bpp_undrawr
    EXTERN  __tms9918_screen_mode
    
    EXTERN  Line_r
    EXTERN  respixel
    INCLUDE "video/tms9918/vdp.inc"


.undrawr_callee
._undrawr_callee    
    pop     af    ; ret addr
    pop     de    ; y
    pop     hl    ; x
    push    af    ; ret addr
    
.asm_undrawr
IFDEF V9938
    ld      a,(__tms9918_screen_mode)
    cp      5
    jp      z,__v9938_4bpp_undrawr
    cp      8
    jp      z,__v9938_8bpp_undrawr
ENDIF
    push    ix
    ld      ix,respixel
    call    Line_r
    pop     ix
    ret

