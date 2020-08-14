MODULE banked_call

SECTION code_driver
PUBLIC banked_call
EXTERN l_jphl

INCLUDE "target/zx/def/sysvar.def"

banked_call:
    pop     hl     ;Return address
    ld      a,(SV_BANKM)
    push    af
    ld      e,(hl)          ; Fetch the call address
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl+)         ; ...and page
    inc     hl              ; Yes this should be here
    push    hl              ; Push the real return address
    ld      bc,32765
    di
    or      16
    ld      (SV_BANKM),a
    out     (c),a
    ei
    ld      l,e
    ld      h,d
    call    l_jphl
    pop     bc              ; Get the return address
    pop     af              ; Pop the old bank
    push    bc
    ld      bc,32765
    di
    ld      (SV_BANKM),a
    out     (c),a
    ei
    ret
