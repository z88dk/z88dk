;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: clg.asm,v 1.3 2001-04-18 13:21:37 stefano Exp $
;


                XLIB    clg
                LIB     swapgfxbk
		XREF	swapgfxbk1

                LIB     cleargraphics
                

.clg
                call    swapgfxbk
                call    cleargraphics
                jp      swapgfxbk1

