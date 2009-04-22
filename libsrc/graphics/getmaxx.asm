;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxx.asm,v 1.1 2009-04-22 17:12:27 stefano Exp $
;


	INCLUDE	"graphics/grafix.inc"


                XLIB    getmaxx

.getmaxx
		ld	hl,maxx
		ret
