
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;   Clear screen, editor and sets the cursor in base position
;   (graphic cursor to lower left, editor cursor to upper left)
;

	SECTION code_clib
	PUBLIC  asm_tvc_cls
    INCLUDE "target/tvc/def/tvc.def"

; Entry:        no entry
;
.asm_tvc_cls
._asm_tvc_cls
    rst     $30
    defb    CLS ; editor - character in
	ret
