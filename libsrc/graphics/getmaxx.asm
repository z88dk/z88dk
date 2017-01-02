;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxx.asm,v 1.5 2017-01-02 21:51:24 aralbrec Exp $
;


	INCLUDE	"graphics/grafix.inc"


                SECTION         code_clib
                PUBLIC    getmaxx
                PUBLIC    _getmaxx

.getmaxx
._getmaxx
		ld	hl,maxx-1
		ret
