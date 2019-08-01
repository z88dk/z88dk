SECTION code_clib
SECTION code_fp_math32

PUBLIC  m32_compare_callee

; Compare two IEEE floats.
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
    pop af          ;return address from this function
                    ;return address to real program
                    ;and the primary on the stack

    exx             ;left
    pop bc
    pop hl
    pop de
    push bc         ;return address to program
    push af         ;return address from this function

    sla e
    rl d
    jr Z,zero_left  ;left is zero (exponent is zero)
    rr d
    rr e

    ld a,l

    exx             ;right
    sla e
    rl d
    jr Z,zero_right ;right is zero (exponent is zero)
    rr d
    rr e

    sub l
    ld c,a

    exx             ;left
    ld a,h

    exx             ;right
    sbc a,h
    ld b,a

    exx             ;left
    ld a,e

    exx             ;right
    sbc a,e

    exx             ;left
    ld c,a
    ld a,d

    exx             ;right
    sbc a,d

    exx             ;left
    ld b,a

    ; left dehl = float, bc = highword of result
    ; (exx) right dehl = float, bc = low word of result
    ld a,b
    or c
    bit 7,b
    jr Z,consider_positive

    ; Calculate zero state of result
.consider_negative
    exx
    or b
    or c

    exx
    ld hl,1    
    scf
    ret

.consider_positive
    exx
    or b
    or c

    exx
    scf
    ccf
    ld hl,1
    ret

.zero_left
    ; left dehl = 0
    ; right dehl' = float
    exx
    ld a,d
    or e
    bit 7,d
    jr Z,zero_negative

.zero_positive
    exx
    or h
    or l

    exx
    scf
    ccf
    ld hl,1
    ret

.zero_right
    ; left dehl' = float
    ; right dehl = 0
    exx
    ld a,d
    or e
    bit 7,d
    jr Z,zero_positive

.zero_negative
    exx
    or h
    or l

    exx
    ld hl,1    
    scf
    ret

