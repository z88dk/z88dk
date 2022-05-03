;   Videoton TV Computer C stub
;   Sandor Vass - 2022
;
;	Set L_STYLE variable
;

	SECTION code_clib
	PUBLIC  tvc_set_linestyle
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        0-16
;
.tvc_set_linestyle
._tvc_set_linestyle
    ld      a,l
    ld      (L_STYLE),a

	ret
