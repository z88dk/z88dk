;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxy.asm,v 1.4 2016-04-13 21:09:09 dom Exp $
;


	INCLUDE	"graphics/grafix.inc"


                SECTION         code_clib
                PUBLIC    getmaxy

.getmaxy
		ld	hl,maxy-1
		ret
