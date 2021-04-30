;Usage: c_unplot(int x, int h)



    SECTION code_graphics
     PUBLIC    c_unplot
     PUBLIC    _c_unplot
     EXTERN    swapgfxbk
     EXTERN    __graphics_end

     EXTERN    c_respixel
    INCLUDE "graphics/grafix.inc"



.c_unplot
._c_unplot
IF __CPU_INTEL__ | __CPU_GBZ80__
    pop    bc
    pop    hl
    pop    de
    push    de
    push    hl
    push    bc
    ld     h,e
ELSE
    push	ix
    ld	ix,2
    add	ix,sp
    ld	l,(ix+2)
    ld	h,(ix+4)
ENDIF
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    call    c_respixel
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
