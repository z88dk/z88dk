;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;	Editor get character
;

	SECTION code_clib
	PUBLIC  tvc_ed_getch
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        no entry
;
.tvc_ed_getch
._tvc_ed_getch
    rst     $30
    defb    ED_CHIN ; editor - character in
    ld l,c
    ld h,0
	ret
