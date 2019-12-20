;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;	Set border colour
;

	SECTION code_clib
	PUBLIC  tvc_set_bordercolor
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        border colour, with border color bits (0x80 is the intensity, etc...)
; In order to work properly U0 must be mapped in.
;
.tvc_set_bordercolor
._tvc_set_bordercolor

    ld      hl,2
    add     hl,sp
    ld      a,(hl)

    ld      (BORDER), a
    out     (PORT_BORDER), a
	ret
