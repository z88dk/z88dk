;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxy.asm,v 1.3 2015-01-19 01:32:46 pauloscustodio Exp $
;


	INCLUDE	"graphics/grafix.inc"


                PUBLIC    getmaxy

.getmaxy
		ld	hl,maxy-1
		ret
