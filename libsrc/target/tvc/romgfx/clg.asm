;
;   Videoton TV Computer asm stub
;   Sandor Vass - 2022
;
;   Clears (graphic) screen, as a sideeffect it also clears the editor and sets pen position to 0,0
;

	SECTION code_clib
	PUBLIC clg
    PUBLIC _clg
    EXTERN tvc_cls
    INCLUDE "target/tvc/def/tvc.def"


    defc clg    = tvc_cls
    defc _clg   = tvc_cls