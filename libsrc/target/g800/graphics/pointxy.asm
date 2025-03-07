
    SECTION code_graphics

    PUBLIC  pointxy

    EXTERN  sety
    EXTERN  setx
    EXTERN  getpat

pointxy:
; in:  hl=x,y
; out: fZ
    push    bc

    call    sety
    call    getpat

    call    setx
    in      a, (c)                   ;dummy read
    in      a, (c)                   ;read data

    and     d
    pop     bc

    ret


