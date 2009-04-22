;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxy.asm,v 1.1 2009-04-22 17:12:27 stefano Exp $
;


	INCLUDE	"graphics/grafix.inc"


                XLIB    getmaxy

.getmaxy
		ld	hl,maxy
		ret
