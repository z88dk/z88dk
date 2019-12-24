;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;   Editor get character
;

    SECTION code_clib
    PUBLIC  tvc_kbd_status
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        no entry
; Return        L: FF-available char, 00-no char available
.tvc_kbd_status
._tvc_kbd_status
    rst     $30
    defb    KBD_STATUS
    ld l,c
    ld h,0
    ret
