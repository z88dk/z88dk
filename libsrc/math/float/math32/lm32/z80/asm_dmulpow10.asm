SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_dmulpow10

EXTERN m32_float8, m32_fsmul_callee, m32_fsdiv_callee
EXTERN _m32_exp10f

   ; multiply DEHL' by a power of ten
   ; DEHL' *= 10^(A)
   ;
   ; enter : DEHL'= float x
   ;            A = signed char
   ;
   ; exit  : success
   ;
   ;         DEHL'= x * 10^(A)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;         DEHL'= +-inf
   ;            carry set, errno set
   ;
   ; note  : for |A| <= 7 the power of ten is an exact 24-bit float and
   ;         the result is a single correctly-rounded multiply or divide.
   ;         For |A| > 7 exp10f is used (the general path may limit the
   ;         power of ten to max one-sided range, eg +-38).
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

.asm_dmulpow10
    ld l,a                  ; l = A (signed)

    bit 7,l
    jr nz, dmul10_neg       ; if A < 0

    ; A >= 0

    cp 8
    jr nc, dmul10_exp10f    ; if A > 7 use exp10f

    ; x * 10^A, 10^A exact

    exx
    push de
    push hl                 ; push x for fsmul
    exx

    add a,a
    add a,a                 ; A *= 4
    ld e,a
    ld d,0
    ld hl,__dmul10_pow10
    add hl,de
    ld c,(hl)
    inc hl
    ld b,(hl)               ; bc = LSW
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)               ; de = MSW
    push bc
    pop hl                  ; hl = LSW

    call m32_fsmul_callee   ; DEHL = x * 10^A
    exx
    ret

dmul10_neg:

    neg                     ; a = |A|

    cp 8
    jr nc, dmul10_neg_big   ; if |A| > 7 divide by 10^|A|

    ; x / 10^|A|, 10^|A| exact

    exx
    push de
    push hl                 ; push x for fsdiv
    exx

    add a,a
    add a,a                 ; |A| *= 4
    ld e,a
    ld d,0
    ld hl,__dmul10_pow10
    add hl,de
    ld c,(hl)
    inc hl
    ld b,(hl)               ; bc = LSW
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)               ; de = MSW
    push bc
    pop hl                  ; hl = LSW

    call m32_fsdiv_callee   ; DEHL = x / 10^|A|
    exx
    ret

dmul10_neg_big:

    ; x / 10^|A|: 10^|A| is a representable normal float up to |A| = 38,
    ; while 10^-|A| would flush to zero (subnormal) for |A| >= 38

    exx
    push de
    push hl                 ; push x for fsdiv
    exx

    ld l,a
    call m32_float8         ; convert l to float in dehl
    call _m32_exp10f        ; make 10^|A|
    call m32_fsdiv_callee   ; DEHL = x / 10^|A|
    exx
    ret

dmul10_exp10f:

    ; l still holds the signed exponent A (the neg above changed a only)

    call m32_float8             ; convert l to float in dehl
    exx

    push de                     ; preserve x, and put it on stack for fsmul
    push hl
    exx

    call _m32_exp10f            ; make 10^A
    call m32_fsmul_callee       ; DEHL = x * 10^(A)
    exx
    ret

SECTION rodata_fp_math32

__dmul10_pow10:
    defb $00,$00,$80,$3f        ; 1.0
    defb $00,$00,$20,$41        ; 10.0
    defb $00,$00,$c8,$42        ; 100.0
    defb $00,$00,$7a,$44        ; 1000.0
    defb $00,$40,$1c,$46        ; 10000.0
    defb $00,$50,$c3,$47        ; 100000.0
    defb $00,$24,$74,$49        ; 1000000.0
    defb $80,$96,$18,$4b        ; 10000000.0