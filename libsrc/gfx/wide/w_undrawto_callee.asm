;
;      Z88 Graphics Functions
;      Written around the Interlogic Standard Library
;
;      Wide resolution (int type parameters) and CALLEE conversion by Stefano Bodrato, 2018
;

;
;    $Id: w_undrawto_callee.asm $
;

; ----- void __CALLEE__ undrawto_callee(int x, int y)


IF !__CPU_INTEL__
    SECTION code_graphics
    PUBLIC undrawto_callee
    PUBLIC _undrawto_callee
    PUBLIC ASMDISP_UNDRAWTO_CALLEE

    EXTERN    swapgfxbk
    ;EXTERN    swapgfxbk1
    EXTERN    w_line
    EXTERN    w_respixel
    EXTERN    __graphics_end
    INCLUDE "graphics/grafix.inc"


.undrawto_callee
._undrawto_callee

   pop af
   pop de
   pop hl
   push af

.asmentry
    push ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    ld     ix,w_respixel
    call    w_line
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

DEFC ASMDISP_UNDRAWTO_CALLEE = asmentry - undrawto_callee
ENDIF
