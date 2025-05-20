

SECTION code_l_sccz80_far
PUBLIC __far_start
PUBLIC __far_end

INCLUDE "target/aquarius/def/aqplus.def"


; Get the initial banking setting
; Exit: a = current bank (or entry value for __far_end)
; Uses; none
__far_start:
    in a,(PORT_BANK3)
    ret

; Get the initial banking setting
; Entry: a = bank to page in
; Uses: none
__far_end:
    out (PORT_BANK3),a
    ret
