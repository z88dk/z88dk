;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: clg.asm,v 1.4 2015-01-19 01:32:46 pauloscustodio Exp $
;


                PUBLIC    clg
                EXTERN     swapgfxbk
		EXTERN	swapgfxbk1

                EXTERN     cleargraphics
                

.clg
                call    swapgfxbk
                call    cleargraphics
                jp      swapgfxbk1

