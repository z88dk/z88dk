;   Videoton TV Computer ASM stub
;   Sandor Vass - 2022
;
;	Sets blocking or interrupting the OS sound play call
;

	SECTION code_clib
	PUBLIC  tvc_set_os_sound_interrupting
    INCLUDE "target/tvc/def/tvc.def"

;
; Input:    L:  0-blocking, 1-interrupting
;
.tvc_set_os_sound_interrupting
._tvc_set_os_sound_interrupting
    ld      a,l
    or      a
    jr      z,a_is_set
    ld      a,$FF
.a_is_set
    ld      (SND_IRQ),a
    ret