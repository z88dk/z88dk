

    MODULE sam_set_screenmode
    SECTION code_clib

    PUBLIC sam_set_screenmode
    PUBLIC _sam_set_screenmode

    PUBLIC asm_sam_set_screenmode
    EXTERN CLIB_SAM_IS_BASIC
    EXTERN __zx_screenmode

    INCLUDE "target/sam/def/sam.def"

; void sam_set_screenmode(int mode)

sam_set_screenmode:
_sam_set_screenmode:
    pop     bc
    pop     hl
    push    hl
    push    bc
    ld      a,l
    dec     a
    and     3

; Entry: a = mode (0-3)
asm_sam_set_screenmode:
    ld      (__zx_screenmode),a
    ld      c,CLIB_SAM_IS_BASIC
    rrc     c
    jr      nc,is_basic
    ; Switch the hardware to the right mode
    rrca
    rrca
    rrca
    and     @01100000
    ld      c,a
    in      a,(VMPR)
    and     @10011111
    or      c
    out     (VMPR),a
    ret

is_basic:
    call    JMODE
    ret



