;   Videoton TV Computer ASM stub
;   Sandor Vass - 2022
;
;	Enable/disable sound
;

	SECTION code_clib
	PUBLIC  tvc_enable_sound
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        0 - disabled, 1 - enabled
;
.tvc_enable_sound
._tvc_enable_sound
    ld      a,l
    or      a
    jr      z,a_set
    ld      a,$10
.a_set
    ld      b,a
    ld      a,(PORT05)
    and     $EF
    or      b
    ld      (PORT05),a
    out     ($05),a
    ret
