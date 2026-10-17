    MODULE  banked_call

    SECTION code_driver
    PUBLIC  banked_call
    EXTERN  l_jphl

IF __CLASSIC
    EXTERN  CLIB_BANKING_STACK_SIZE
ELSE
    defc CLIB_BANKING_STACK_SIZE = 100
ENDIF

    INCLUDE "target/zx/def/sysvar.def"

banked_call:
    di
    pop     hl                          ;Return address
    ld      (___z88dk_banked_mainsp), sp
    ld      sp, (___z88dk_banked_banksp)
    ld      a, (SV_BANKM)
    push    af
    ld      e, (hl)                     ; Fetch the call address
    inc     hl
    ld      d, (hl)
    inc     hl
    ld      a, (hl)                     ; ...and page
    inc     hl
    inc     hl                          ; Yes this should be here
    push    hl                          ; Push the real return address
    ld      (___z88dk_banked_banksp), sp
    ld      sp, (___z88dk_banked_mainsp)
    ld      bc, 32765
    or      16
    ld      (SV_BANKM), a
    out     (c), a
    ei
    ld      l, e
    ld      h, d
    call    l_jphl
    di
    ld      (___z88dk_banked_mainsp), sp
    ld      sp, (___z88dk_banked_banksp)
    pop     bc                          ; Get the return address
    pop     af                          ; Pop the old bank
    ld      (___z88dk_banked_banksp), sp
    ld      sp, (___z88dk_banked_mainsp)
    push    bc
    ld      bc, 32765
    ld      (SV_BANKM), a
    out     (c), a
    ei
    ret


    SECTION code_crt_init

IF __CLASSIC
    pop     de
ENDIF
    ld      (___z88dk_banked_banksp), sp
    ld      hl, -CLIB_BANKING_STACK_SIZE
    add     hl, sp
    ld      sp, hl
IF __CLASSIC
    push    de
ENDIF

    SECTION bss_driver

; z88dk-ticks finds these two variables by name to unwind a banked call.
; The bank stack holds, for each call, the real return address and then af
; with the saved bank in a.
___z88dk_banked_mainsp:
    defw    0
___z88dk_banked_banksp:
    defw    0
