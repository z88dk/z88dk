;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;   Get the pen up from paper
;

	SECTION code_clib
	PUBLIC  pen_up
    INCLUDE "target/tvc/def/tvc.def"

; Entry:        no entry
;
.pen_up
._pen_up
    rst     $30
    defb    BOFF ; pen off
	ret