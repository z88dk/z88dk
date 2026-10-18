; Rabbit banked call
;
;   call banked_call
;   defq target             ; bank number in the bits above 16
;
; Maps the bank into the XPC window (XPC = bank * 2), calls the target and
; restores XPC. The old XPC and the real return address are kept on a
; separate stack, so the callee sees an ordinary near-call frame.
;
; Rabbit 2000 and 3000: 8-bit XPC, banks 1 to 120.
; Rabbit 4000 and later: the bank is 16 bits and the whole 12-bit LXPC is
; saved, so banks go up to 2040 (the 16MB space).
;
; Corrupts: a, bc. Preserves hl and de for the return value.

    SECTION code_l_sccz80

    PUBLIC  banked_call
    EXTERN  l_dcal
    EXTERN  CLIB_BANKING_STACK_SIZE

banked_call:
IF __CPU_R4K__ || __CPU_R5K__ || __CPU_R6K__
    ; Rabbit 4000 and later: the bank is 16 bits (the two upper bytes of the
    ; defq) and the whole 12-bit LXPC is saved and restored. The bank stack
    ; holds, for each call, the real return address and then the caller's LXPC.
    ipset   3
    pop     de                          ; inline target
    ld      (___z88dk_banked_mainsp),sp
    ld      sp,(___z88dk_banked_banksp)
    ld      hl,lxpc
    push    hl                          ; caller's LXPC
    ex      de,hl                       ; hl = inline target
    ld      e,(hl)                      ; address
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)                      ; bank
    inc     hl
    ld      b,(hl)
    inc     hl
    push    hl                          ; real return address
    ld      (___z88dk_banked_banksp),sp
    ld      sp,(___z88dk_banked_mainsp)
    ld      h,b
    ld      l,c
    add     hl,hl                       ; lxpc = bank * 2
    ld      lxpc,hl
    ipres
    ex      de,hl                       ; hl = address
    call    l_dcal
    ipset   3
    ld      (___z88dk_banked_mainsp),sp
    ld      sp,(___z88dk_banked_banksp)
    pop     bc                          ; real return address
    ex      (sp),hl                     ; hl = caller's LXPC, return value on the stack
    ld      lxpc,hl
    pop     hl                          ; return value
    ld      (___z88dk_banked_banksp),sp
    ld      sp,(___z88dk_banked_mainsp)
    push    bc
    ipres
    ret
ELSE
    ipset   3
    pop     hl                          ; inline target
    ld      (___z88dk_banked_mainsp),sp
    ld      sp,(___z88dk_banked_banksp)
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
    ld      (___z88dk_banked_banksp),sp
    ld      sp,(___z88dk_banked_mainsp)
    add     a,a
    ld      xpc,a
    ipres
    ld      l,e
    ld      h,d
    call    l_dcal
    ipset   3
    ld      (___z88dk_banked_mainsp),sp
    ld      sp,(___z88dk_banked_banksp)
    pop     bc                          ; real return address
    pop     af                          ; caller's XPC
    ld      (___z88dk_banked_banksp),sp
    ld      sp,(___z88dk_banked_mainsp)
    ld      xpc,a
    push    bc
    ipres
    ret
ENDIF


    SECTION code_crt_init

    pop     de                          ; crt0_init return address
    ld      (___z88dk_banked_banksp),sp
    ld      hl,-CLIB_BANKING_STACK_SIZE
    add     hl,sp
    ld      sp,hl
    push    de


    SECTION bss_driver

; z88dk-ticks finds these two variables by name to unwind a banked call.
; The bank stack holds, for each call, the real return address and then af
; with the saved bank in a.
___z88dk_banked_mainsp:
    defw    0
___z88dk_banked_banksp:
    defw    0
