;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxy.asm,v 1.2 2009-04-23 10:16:22 stefano Exp $
;


	INCLUDE	"graphics/grafix.inc"


                XLIB    getmaxy

.getmaxy
		ld	hl,maxy-1
		ret
