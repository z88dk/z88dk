;
;       Turtle graphics library
;       Stefano - 11/2017
;

    SECTION code_clib
    PUBLIC  fwd
    PUBLIC  _fwd

    EXTERN  l_mult
    EXTERN  l_div
    EXTERN  icos
    EXTERN  isin
    EXTERN  move

    EXTERN  __direction

.fwd
._fwd
    ; __FASTCALL

    push    hl
    ld      hl,(__direction)
    call    icos
    pop     de
    push    de
    call    l_mult
    ld      de,256
    ex      de,hl
    call    l_div

    pop     de
    push    hl
    push    de

    ld      hl,(__direction)
    call    isin
    pop     de
    call    l_mult
    ld      de,256
    ex      de,hl
    call    l_div

    push    hl

    call    move
    pop     hl
    pop     hl
    ret
