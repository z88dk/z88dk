    MODULE  __sam_set_mode

    PUBLIC  sam_set_screenmode
    PUBLIC  _sam_set_screenmode
    PUBLIC  asm_sam_set_screenmode
    EXTERN  __zx_mode0_console_w
    EXTERN  __console_w
    EXTERN  __zx_screenmode
    EXTERN  CLIB_SAM_IS_BASIC

    INCLUDE "target/sam/def/sam.def"



sam_set_screenmode:
_sam_set_screenmode:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)

; Set the screen mode (called via ioctl)
; Entry: a = screen mode (1,2,3,4)
asm_sam_set_screenmode:
    dec     a
    cp      4
    ret     nc
    ld      c,a
    ld      a,(__zx_mode0_console_w)
    ld      b,a
    ld      a,c
    and     a
    jr      z,set_it    ;Mode 1
    ld      b,32
    cp      1           ;Mode 2
    jr      z,set_it
    cp      3           ;Mode 4
    jr      z,set_it
    ld      b,64        ;We're in mode3
set_it:
    ld      (__zx_screenmode),a
    ld      c,CLIB_SAM_IS_BASIC
    rrc     c
    jr      c,is_basic
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
    ld      a,b
    ld      (__console_w),a
    ret

is_basic:
    push    bc
    call    JMODE
    pop     bc
    ld      a,b
    ld      (__console_w),a
    ret
