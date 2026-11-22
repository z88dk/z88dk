

SECTION code_l_sccz80_far
PUBLIC __far_start
PUBLIC __far_end

INCLUDE "target/zx/def/sysvar.def"


; Get the initial banking setting
; Exit: a = current bank (or entry value for __far_end)
; Uses; f
__far_start:
    ld      a,(SV_BANKM)
    and     7
    ret

; Get the initial banking setting
; Entry: a = bank to page in
; Uses: f
__far_end:
    di              ;Should really call l_push_di
    push    bc
    ld      c,a
    ld      a,(SV_BANKM)
    and     @11111000
    or      c
    ld      bc,32765
    out     (c),a
    ld      (SV_BANKM),a
    pop     bc
    ei
    ret
