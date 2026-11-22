

SECTION code_l_sccz80_far
PUBLIC __far_start
PUBLIC __far_end

INCLUDE "target/sam/def/sam.def"

EXTERN  THIS_FUNCTION_ONLY_WORKS_WITH_ALLRAM_SUBTYPE
defc    __subtype_protection=THIS_FUNCTION_ONLY_WORKS_WITH_ALLRAM_SUBTYPE


; Get the initial banking setting
;
; Exit: a = current bank (or entry value for __far_end)
; Uses; none
__far_start:
    in a,(HMPR)
    ret

; Get the initial banking setting
; Entry: a = bank to page in
; Uses: none
__far_end:
    out (HMPR),a
    ret
