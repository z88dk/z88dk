;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;	Editor get character
;

	SECTION code_clib
	PUBLIC  tvc_ed_cpos
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        (column, row) / X,Y
;
.tvc_ed_cpos
._tvc_ed_cpos

    ld      hl,2
    add     hl,sp
    ld      c,(hl)
    inc     hl
    inc     hl
    ld      b,(hl)

    rst     $30     ; C-row, B-column
    defb    ED_CPOS ; editor - character in
    ld      c,l
    ld      h,0
	ret
