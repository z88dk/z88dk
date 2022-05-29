;   Videoton TV Computer ASM stub
;   Sandor Vass - 2022
;
;	Sets the sound pitch to the given raw value.
;

	SECTION code_clib
	PUBLIC  tvc_set_sound_pitch_raw
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        hl contains the raw pitch value
;
.tvc_set_sound_pitch_raw
._tvc_set_sound_pitch_raw
    ld      a,(PORT05)
    and     $f0
    ld      b,a
    ld      a,h
    and     $0f
    or      b
    ld      (PORT05),a
    out     ($05),a
    ld      a,l
    out     ($04),a
    ret