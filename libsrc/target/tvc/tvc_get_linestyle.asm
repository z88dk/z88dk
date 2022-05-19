;   Videoton TV Computer C stub
;   Sandor Vass - 2022
;
;	Returns the value of L_STYLE system variable
;

	SECTION code_clib
	PUBLIC  tvc_get_linestyle
    INCLUDE "target/tvc/def/tvc.def"

.tvc_get_linestyle
._tvc_get_linestyle
    ld      a,(L_STYLE)
    ld      l,a
    ld      h,0

	ret
