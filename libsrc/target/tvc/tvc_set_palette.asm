;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;	Set border colour
;

	SECTION code_clib
	PUBLIC  tvc_set_palette
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        border colour, palette index
;
.tvc_set_palette
._tvc_set_palette

    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    or a
    jp m,quit
    cp $04      ; palette index can be 0-3
    jr nc,quit
    add a,$60
    ld c,a

    inc hl
    inc hl
    ld a,(hl)
    out (c),a

.quit
	ret
