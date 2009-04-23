;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxx.asm,v 1.2 2009-04-23 10:16:22 stefano Exp $
;


	INCLUDE	"graphics/grafix.inc"


                XLIB    getmaxx

.getmaxx
		ld	hl,maxx-1
		ret
