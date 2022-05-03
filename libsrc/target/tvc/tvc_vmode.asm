;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;	Set video mode
;

	SECTION code_clib
	PUBLIC  tvc_vmode
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        0, 1, 2 - 2c, 4c, 16c mode
;
.tvc_vmode
._tvc_vmode

    ld      hl,2
    add     hl,sp
    ld      c,(hl)

    rst     $30     
    defb    VMODE   ; Video mode. 0, 1, 2 -> 2color, 4color, 16 color mode
    ld      l,c
    ld      h,0
	ret
