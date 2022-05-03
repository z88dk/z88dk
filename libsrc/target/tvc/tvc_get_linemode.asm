;   Videoton TV Computer C stub
;   Sandor Vass - 2022
;
;	Returns the value of L_MODE system variable
;

	SECTION code_clib
	PUBLIC  tvc_get_linemode
    INCLUDE "target/tvc/def/tvc.def"

.tvc_get_linemode
._tvc_get_linemode
    ld      a,(L_MODE)
    ld      l,a
    ld      h,0

	ret
