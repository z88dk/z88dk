;
;      Z88 Graphics Functions - Small C+ stubs
;
;      Written around the Interlogic Standard Library
;
;      Stubs Written by D Morris - 30/9/98
;
;
;	$Id: clg.asm,v 1.6 2016-04-13 21:09:09 dom Exp $
;


    SECTION        code_graphics
    PUBLIC    clg
    PUBLIC    _clg
    EXTERN    swapgfxbk
    EXTERN	__graphics_end

    EXTERN    cleargraphics
    INCLUDE "graphics/grafix.inc"


.clg
._clg
IF !__CPU_INTEL__ & !__CPU_GBZ80__
    push	ix
ENDIF
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF 
    call    cleargraphics
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
