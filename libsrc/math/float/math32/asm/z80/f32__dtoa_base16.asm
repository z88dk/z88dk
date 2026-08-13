
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_base16

.m32__dtoa_base16

    ; enter : DEHL'= float x, x positive
    ;
    ; exit  : HL'= mantissa *
    ;         DE'= stack adjust
    ;          C = max number of significant hex digits (6)
    ;          D = base 2 exponent e
    ;
    ; uses  : af, c, d, hl, bc', de', hl'

    exx
    pop bc

    sla e
    rl d
    ld a,d

    scf
    rr e

    push de                     ; push mantissa onto the stack
    push hl

    push bc

    ld hl,4
    add hl,sp                   ; hl = mantissa *

    ld de,4

    exx
    sub $7e                     ; subtract excess (bias - 1)
    ld d,a                      ; d = base 2 exponent

    ld c,6                      ; max 6 hex digits
    ret

