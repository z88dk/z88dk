; Rabbit banked call
;
;   call banked_call
;   defq target             ; bank number in the bits above 16
;
; Maps the bank into the XPC window (XPC = bank * 2), calls the target and
; restores XPC. The old XPC and the real return address are kept on a
; separate stack, so the callee sees an ordinary near-call frame.
; Corrupts: af, bc'. Preserves hl, de for the return value.

    SECTION code_l_sccz80

    PUBLIC  banked_call
    EXTERN  l_dcal
    EXTERN  CLIB_BANKING_STACK_SIZE

banked_call:
    ipset   3
    pop     hl                          ; inline target
    ld      (banked_mainsp),sp
    ld      sp,(banked_tempsp)
    ld      a,xpc
    push    af                          ; caller's XPC
    ld      e,(hl)                      ; address
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)                      ; bank
    inc     hl
    inc     hl                          ; skip the rest of the defq
    push    hl                          ; real return address
    ld      (banked_tempsp),sp
    ld      sp,(banked_mainsp)
    add     a,a
    ld      xpc,a
    ipres
    ld      l,e
    ld      h,d
    call    l_dcal
    ipset   3
    ld      (banked_mainsp),sp
    ld      sp,(banked_tempsp)
    pop     bc                          ; real return address
    pop     af                          ; caller's XPC
    ld      (banked_tempsp),sp
    ld      sp,(banked_mainsp)
    ld      xpc,a
    push    bc
    ipres
    ret


    SECTION code_crt_init

    pop     de                          ; crt0_init return address
    ld      (banked_tempsp),sp
    ld      hl,-CLIB_BANKING_STACK_SIZE
    add     hl,sp
    ld      sp,hl
    push    de


    SECTION bss_driver

banked_mainsp:
    defw    0
banked_tempsp:
    defw    0
