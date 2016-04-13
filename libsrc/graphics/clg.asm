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


                SECTION         code_clib
                PUBLIC    clg
                PUBLIC    _clg
                EXTERN     swapgfxbk
		EXTERN	__graphics_end

                EXTERN     cleargraphics
                

.clg
._clg
		push	ix
                call    swapgfxbk
                call    cleargraphics
                jp      __graphics_end

