
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_base16

m32__dtoa_base16:

    ; enter : DEHL'= double x, x positive
    ;
    ; exit  : HL'= mantissa *
    ;         DE'= stack adjust
    ;          C = max number of significant hex digits (6)
    ;          D = base 2 exponent e
    ;
    ; uses  : af, c, d, hl, bc', de', hl'
#if 0
    exx
    pop bc

    sla e
    rl d
    ld a,d

    srl e

    set 7,e                     ; push mantissa onto the stack
    ld d,e
    ld e,h
    ld h,l

    push de
    push hl

    push bc

    ld hl,6
    add hl,sp                   ; hl = mantissa *

    ld de,6

    exx
    sub $fe
    ld d,a                      ; d = base 2 exponent

    ld c,6                      ; max 6 hex digits
    ret

#endif
