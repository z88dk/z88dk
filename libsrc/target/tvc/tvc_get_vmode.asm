;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;	Get video mode
;

	SECTION code_clib
	PUBLIC  tvc_get_vmode
    INCLUDE "target/tvc/def/tvc.def"

;
; Returns:        0, 1, 2 - 2c, 4c, 16c mode
;
.tvc_get_vmode
._tvc_get_vmode

    ld hl,PORT06
    ld a,(hl)
    and $03
    cp $03
    jr nz,done ; 2 and 3 means 16 colors, but only 1 enum is defined for that...
    dec a
.done
    ld      l,a
    ld      h,0
	ret
