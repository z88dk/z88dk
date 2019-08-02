SECTION code_clib
SECTION code_fp_math32

PUBLIC  m32_compare_callee

; Compare two IEEE floats.
;
; IEEE float is considered zero if exponent is zero.
;
; To compare our floating point numbers, we define the following rules:
;       Always flip the sign bit.
;       If the sign bit was set (negative), flip the other bits too.
;       http://stereopsis.com/radix.html
;
;       Entry: dehl  = right
;              stack = left, ret, ret
;
;       Exit:      Z = number is zero
;               (NZ) = number is non-zero
;                  C = number is negative 
;                 NC = number is positive
;
;       Uses: af, bc, de, hl, bc', de', hl'

.m32_compare_callee
                        ;right
    pop af              ;return address from this function
                        ;return address to real program
                        ;and the primary on the stack

    exx                 ;left
    pop bc
    pop hl
    pop de
    push bc             ;return address to program
    push af             ;return address from this function

    sla e
    rl d
    jr Z,zero_left      ;left is zero (exponent is zero)
    ccf
    jr C,positive_left
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
    ld a,e
    cpl
    ld e,a
    ld a,d
    cpl
    ld d,a

.positive_left
    rr d
    rr e

    exx                 ;right
    sla e
    rl d
    jr Z,zero_right     ;right is zero (exponent is zero)
    ccf
    jr C,positive_right
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
    ld a,e
    cpl
    ld e,a
    ld a,d
    cpl
    ld d,a

.positive_right
    rr d
    rr e

    exx                 ;left
    ld a,l

    exx                 ;right
    sub l
    ld c,a

    exx                 ;left
    ld a,h

    exx                 ;right
    sbc a,h
    ld b,a

    exx                 ;left
    ld a,e

    exx                 ;right
    sbc a,e

    exx                 ;left
    ld c,a
    ld a,d

    exx                 ;right
    sbc a,d

    exx                 ;left
    ; dehl  =  left float, ac  = high word of result
    ; dehl' = right float, bc' =  low word of result
    jr C,consider_negative

.consider_positive
    ; Calculate whether result is zero (equal)
    or c
    exx
    or b
    or c
.return_positive
    ld hl,1
    scf
    ccf
    ret

.consider_negative
    ; Calculate whether result is zero (equal)
    or c
    exx
    or b
    or c
.return_negative
    ld hl,1
    scf
    ret

.zero_left
    ;   left dehl = 0
    ;   right dehl' = float
    exx
    sla e
    rl d
    jr C,return_positive
    jr Z,return_positive    ;both right and left are zero
    jr return_negative

.zero_right
    ;   left dehl' = -float
    ;   right dehl = 0    
    exx
    sla e
    rl d
    jr C,return_positive
    inc d                   ;reverse cpl on left exponent
    jr Z,return_positive    ;both right and left are zero
    jr return_negative

