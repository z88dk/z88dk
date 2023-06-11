

;
; Entry: E'H'L'=far pointer
;        HL=word

lp_pint:
    push    hl
    exx
    defb    $5b    ;lil
    push    hl
    defb    $5b    ;lil
    ld      hl,2
    defb    0
    defb    $5b
    add     hl,sp
    defb    $5b
    ld      (hl),e
    defb    $5b
    pop     hl
    pop     de
    defb    $5b
    ld      (hl),e
    inc     hl
    defb    $5b
    ld      (hl),d
    ret
