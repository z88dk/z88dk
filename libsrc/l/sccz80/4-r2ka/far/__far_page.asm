; Rabbit far access: map a far address into the XPC window
;
; A far address is a 24-bit physical address in e:bc. With e = 0 it is a
; local (logical) address and is used as it is. Otherwise the 4k page that
; holds it is put in the window, so that
;
;   physical = xpc * 0x1000 + hl,   hl in 0xE000-0xFFFF
;
; Entry: ebc = far address
;         a' = XPC to use for local addresses (from __far_start)
; Exit:   hl = address to access
;        ebc = unchanged
;
; Corrupts: a, d. The caller's stack must be below 0xE000, or it is moved
; out from under it with the window.

    SECTION code_l_sccz80_far
    PUBLIC  __far_page

__far_page:
    ld      a,e
    and     a
    jr      z,localfar
    ld      a,b                     ; xpc = (ebc >> 12) - 0xe
    rrca
    rrca
    rrca
    rrca
    and     $0f
    ld      d,a
    ld      a,e
    rlca
    rlca
    rlca
    rlca
    and     $f0
    or      d
    sub     $0e
    ld      xpc,a
    ld      a,b                     ; hl = 0xe000 + (ebc & 0xfff)
    and     $0f
    or      $e0
    ld      h,a
    ld      l,c
    ret

localfar:
    ex      af,af'
    ld      xpc,a
    ex      af,af'
    ld      h,b
    ld      l,c
    ret
