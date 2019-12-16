;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;	Editor get character
;

	SECTION code_clib
	PUBLIC  tvc_ed_cfix
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        no entry
;
.tvc_ed_cfix
._tvc_ed_cfix
    rst     $30
    defb    ED_CFIX ; editor - character in
	ret
