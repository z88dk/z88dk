SECTION code_clib
SECTION code_fp_math32

PUBLIC  m32_compare_callee

; Compare two IEEE floats.
;
; IEEE float is considered zero if exponent is zero.
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
    rr d
    rr e

    ld a,l

    exx                 ;right
    sla e
    rl d
    jr Z,zero_right     ;right is zero (exponent is zero)
    rr d
    rr e

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
    ld b,a

    ; left dehl = float, bc = highword of result
    ; (exx) right dehl = float, bc = low word of result
    ld a,b
    or c
    bit 7,b
    jr Z,consider_positive

    ; Calculate whether result is zero (equal)
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
    ld hl,1    
    scf
    ccf
    ret

.zero_left
    ; left dehl = 0
    ; right dehl' = float
    exx
    sla e
    rl d
    jr Z,comp_positive  ;right is zero
    jr C,comp_positive  ;sign of right is negative

.comp_negative
    ld hl,1
    scf
    ret

.zero_right
    ; left dehl' = float
    ; right dehl = 0
    exx
    sla e
    rl d
    jr C,comp_negative  ;sign of left is negative

.comp_positive
    ld hl,1
    scf
    ccf
    ret

