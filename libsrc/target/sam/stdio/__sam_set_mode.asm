    MODULE  __sam_set_mode

    PUBLIC  __sam_set_mode

    EXTERN  asm_sam_set_screenmode

    EXTERN  __zx_printc64
    EXTERN  __sam_printc

    INCLUDE "target/sam/def/sam.def"

; Set the screen mode (called via ioctl)
; Entry: a = screen mode (1,2,3,4)
__sam_set_mode:
    dec     a
    cp      4
    ret     nc
    ld      hl,__zx_printc64
    ld      b,64
    and     a
    jr      z,set_it
    ld      b,32
    ld      hl,__sam_printc
    cp      3
    jr      z,set_it
    ld      b,64
set_it:
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
    
