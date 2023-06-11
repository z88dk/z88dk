

;
; Entry: EHL=far pointer
; Exit: EHL=pointer stored there...

lp_glong:
    defb    $5b    ;lil
    push    hl
    defb    $5b    ;lil
    ld      hl,2
    defb    0
    defb    $5b
    add     hl,sp
    defb    $5b
    ld      (hl),e
    defb   $5b
    pop     hl

    defb    $5b, $ed, $27	;ld.lil hl,(hl)
    inc     hl
    inc     hl
    defb    $5b
    defb    $5b, $ed, $17	;ld.lil de,(hl)
    ret
