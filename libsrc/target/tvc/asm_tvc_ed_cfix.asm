;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;	Editor get character
;

	SECTION code_clib
	PUBLIC  asm_tvc_ed_cfix
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        no entry
;
.asm_tvc_ed_cfix
._asm_tvc_ed_cfix
    rst     $30
    defb    ED_CFIX ; editor - character in
	ret
