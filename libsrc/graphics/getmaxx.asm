;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxx.asm,v 1.3 2015-01-19 01:32:46 pauloscustodio Exp $
;


	INCLUDE	"graphics/grafix.inc"


                PUBLIC    getmaxx

.getmaxx
		ld	hl,maxx-1
		ret
