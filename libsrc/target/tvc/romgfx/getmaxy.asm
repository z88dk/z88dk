;
;   Videoton TV Computer asm stub
;   Sandor Vass - 2022
;
;	Returns maximum Y coordinate (in all graphics resolution)
;

	SECTION code_clib
	PUBLIC getmaxy
    PUBLIC _getmaxy
    INCLUDE "target/tvc/def/tvc.def"


.getmaxy
._getmaxy
    ld	    hl,ROM_RESY - 1
    ret