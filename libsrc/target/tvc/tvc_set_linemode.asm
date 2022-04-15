;   Videoton TV Computer C stub
;   Sandor Vass - 2022
;
;	Set L_MODE mode
;

	SECTION code_clib
	PUBLIC  tvc_set_linemode
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        0-3
;
.tvc_set_linemode
._tvc_set_linemode
    ld      a,l
    ld      (L_MODE),a

	ret
