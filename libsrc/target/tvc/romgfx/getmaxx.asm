;
;   Videoton TV Computer asm stub
;   Sandor Vass - 2022
;
;	Returns maximum X coordinate (in all graphics resolution)
;

	SECTION code_clib
	PUBLIC getmaxx
    PUBLIC _getmaxx
    INCLUDE "target/tvc/def/tvc.def"


.getmaxx
._getmaxx
    ld	    hl,ROM_RESX - 1
    ret