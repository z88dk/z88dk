;   Videoton TV Computer ASM stub
;   Sandor Vass - 2022
;
;	Plays a sound for a specifed duration (in 22ms)
;

	SECTION code_clib
	PUBLIC  tvc_play_os_sound
    INCLUDE "target/tvc/def/tvc.def"

;
; 
;
.tvc_play_os_sound
._tvc_play_os_sound
    ld      hl,2
    add     hl,sp
    ld      b,(hl)
    inc     hl
    inc     hl
    ld      c,(hl)
    inc     hl
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    rst     $30
    db      TONE_SET
    ret
