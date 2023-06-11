;   Videoton TV Computer ASM stub
;   Sandor Vass - 2022
;
;	Returns if OS is playing a sound or not
;

	SECTION code_clib
	PUBLIC  tvc_is_os_sound_playing
    INCLUDE "target/tvc/def/tvc.def"

;
; Returns false (0) if no sound is being played, true (1) otherwise
;
.tvc_is_os_sound_playing
._tvc_is_os_sound_playing
    ld      h,0
    ld      l,h
    ld      a,(SND_ACTIVE)
    or      a
    ret     z
    inc     l
    ret
