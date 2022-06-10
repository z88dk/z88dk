;   Videoton TV Computer ASM stub
;   Sandor Vass - 2022
;
;	Sets the sound volume
;

	SECTION code_clib
	PUBLIC  tvc_set_sound_volume
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        Lower 4 bits of L contains the volume (0-15)
.tvc_set_sound_volume
._tvc_set_sound_volume
    ld      a,l
    and     $0F
    rlca
    rlca
    ld      b,a
    ld      a,(PORT06)
    and     $C3
    or      b
    ld      (PORT06),a
    out     ($06),a
    ret