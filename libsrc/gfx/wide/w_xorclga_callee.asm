
;
;      Z88 Graphics Functions - Small C+ stubs
;
;      Written around the Interlogic Standard Library
;
;
;    $Id: w_xorclga_callee.asm $
;


;Usage: xorclga(struct *pixels)

IF !__CPU_INTEL__
    SECTION code_graphics
    
    PUBLIC    xorclga_callee
    PUBLIC    _xorclga_callee
    
    PUBLIC    ASMDISP_XORCLGA_CALLEE

    EXTERN    w_xorpixel
    EXTERN    w_area

    EXTERN    swapgfxbk
    EXTERN    __graphics_end
    INCLUDE "graphics/grafix.inc"

    
.xorclga_callee
._xorclga_callee

    pop af
    
    pop de
    pop    hl
    exx        ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop de
    pop hl
    
    push af    ; ret addr
    
    exx
    
.asmentry
    
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF    
    ld     ix,w_xorpixel
    call    w_area

IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
DEFC ASMDISP_XORCLGA_CALLEE = asmentry - xorclga_callee
ENDIF
