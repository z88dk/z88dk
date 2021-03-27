;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;     Stubs Written by D Morris - 30/9/98
;
;
;    $Id: unplot_callee.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  unplot(int x, int y)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC    unplot_callee
    PUBLIC    _unplot_callee
    PUBLIC    ASMDISP_UNPLOT_CALLEE

    EXTERN    swapgfxbk
    EXTERN    __graphics_end

    EXTERN    respixel
    INCLUDE    "graphics/grafix.inc"


.unplot_callee
._unplot_callee
    pop    af    ; ret addr
    pop hl    ; y
    pop de    ; x
    ld    h,e
    push    af    ; ret addr

.asmentry
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF    
    call    respixel
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
DEFC ASMDISP_UNPLOT_CALLEE = asmentry - unplot_callee
ENDIF
