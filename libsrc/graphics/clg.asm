;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;




                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    clg
                LIB     swapgfxbk
		XREF	swapgfxbk1

                LIB     cleargraphics


.clg
                call    swapgfxbk
                call    cleargraphics
                jp      swapgfxbk1

