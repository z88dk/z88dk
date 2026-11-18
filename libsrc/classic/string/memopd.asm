; CALLER linkage for function pointers

    PUBLIC  memopd
    PUBLIC  _memopd
    EXTERN  asm_memopd

memopd:
_memopd:

    ; asm_memopd loads ix with the op, so keep the caller's ix (frame pointer)
    push    ix
    ld      hl, 4                       ; skip saved ix and return address
    add     hl, sp
    ld      e, (hl)
    inc     hl
    ld      d, (hl)                     ; de = op
    inc     hl
    ld      c, (hl)
    inc     hl
    ld      b, (hl)                     ; bc = n
    inc     hl
    push    de
    pop     ix                          ; ix = op
    ld      e, (hl)
    inc     hl
    ld      d, (hl)                     ; de = src
    inc     hl
    ld      a, (hl)
    inc     hl
    ld      h, (hl)
    ld      l, a                        ; hl = dst
    call    asm_memopd
    pop     ix
    ret
