;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: clg.asm,v 1.6 2016-04-13 21:09:09 dom Exp $
;


                SECTION         code_graphics
                PUBLIC    clg
                PUBLIC    _clg
                EXTERN     swapgfxbk
		EXTERN	__graphics_end

                EXTERN     cleargraphics
                

.clg
._clg
IF !__CPU_INTEL__ & !__CPU_GBZ80__
		push	ix
ENDIF
                call    swapgfxbk
                call    cleargraphics
                jp      __graphics_end

