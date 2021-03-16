    MODULE  asm_sam_set_mode

    PUBLIC  asm_sam_set_mode

    EXTERN  __zx_screenmode
    EXTERN  __zx_print_routine
    EXTERN  __zx_printc64
    EXTERN  __sam_printc
    EXTERN  __console_w

    INCLUDE "target/sam/def/sam.def"

; Set the screen mode
; Entry: a = screen mode (1,2,3,4)
; TODO: Rename, this does too much to be general purpose
asm_sam_set_mode:
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
    jr      nz,set_it
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
    ld      a,b
    ld      (__console_w),a
    ld      (__zx_print_routine),hl
    ret
    