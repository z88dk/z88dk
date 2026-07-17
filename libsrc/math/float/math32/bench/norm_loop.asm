;
; Loop normalize alternative for ticks (not production)
; enter: LDE = mantissa (hidden form), C = exp, B = sign
; exit: DEHL packed float-ish
SECTION code_user
PUBLIC norm_loop
.norm_loop
    ld a,l
    or d
    or e
    ret Z
.lp
    ld a,l
    and $80
    ret NZ
    ; mant << 1 : LDE
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    ld a,l
    rla
    ld l,a
    dec c
    jp NZ,lp
    ret
