;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxy.asm,v 1.5 2017-01-02 21:51:24 aralbrec Exp $
;


	INCLUDE	"graphics/grafix.inc"


                SECTION         code_clib
                PUBLIC    getmaxy
                PUBLIC    _getmaxy

.getmaxy
._getmaxy
		ld	hl,maxy-1
		ret
