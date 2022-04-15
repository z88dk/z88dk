;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;   Put pen down on paper
;

	SECTION code_clib
	PUBLIC  pen_down
    INCLUDE "target/tvc/def/tvc.def"

; Entry:        no entry
;
.pen_down
._pen_down
    rst     $30
    defb    BON ; pen on
	ret