; ----- void __CALLEE__ drawr(int x2, int y2)

    SECTION code_video_vdp

    PUBLIC  drawr_callee
    PUBLIC  _drawr_callee
    
    PUBLIC  asm_drawr

    EXTERN  __v9938_4bpp_drawr
    EXTERN  __v9938_8bpp_drawr
    EXTERN  __tms9918_screen_mode
    
    EXTERN  Line_r
    EXTERN  plotpixel
    INCLUDE "video/tms9918/vdp.inc"


.drawr_callee
._drawr_callee    
    pop     af    ; ret addr
    pop     de    ; y
    pop     hl    ; x
    push    af    ; ret addr
    
.asm_drawr
IFDEF V9938
    ld      a,(__tms9918_screen_mode)
    cp      5
    jp      z,__v9938_4bpp_drawr
    cp      8
    jp      z,__v9938_4bpp_drawr
ENDIF
    push    ix
    ld      ix,plotpixel
    call    Line_r
    pop     ix
    ret

