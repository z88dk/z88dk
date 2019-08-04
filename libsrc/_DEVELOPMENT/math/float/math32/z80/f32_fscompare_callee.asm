SECTION code_clib
SECTION code_fp_math32

PUBLIC  m32_compare_callee

; Compare two IEEE floats.
;
; IEEE float is considered zero if exponent is zero.
;
; To compare our floating point numbers across whole number range,
; we define the following rules:
;       - Always flip the sign bit.
;       - If the sign bit was set (negative), flip the other bits too.
;       http://stereopsis.com/radix.html, et al.
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
    exx                 ;left
    pop af              ;return address from this function
    pop bc              ;return address to real program
    pop hl              ;and the left (primary) on the stack
    pop de
    push bc
    push af

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

    ; dehl  = right float, bc   =  low word of result
    ; dehl' =  left float, a,c' = high word of result
    jr C,consider_negative

.consider_positive
    ; Calculate whether result is zero (equal)
    or c
    or b
    exx                 ;left
    or c
.return_positive
    ld hl,1
    scf
    ccf
    ret

.consider_negative
    ; Calculate whether result is zero (equal)
    or c
    or b
    exx                 ;left
    or c
.return_negative
    ld hl,1
    scf
    ret

.zero_right
    ;   right dehl = 0    
    ;   left dehl' = float
    exx                 ;left
    sla e
    rl d
    jr NC,return_positive
    jr Z,return_positive    ;both left and right are zero
    jr return_negative

.zero_left
    ;   left dehl = 0
    ;   right dehl' = (cpl if negative)float non-zero
    exx                 ;right
    sla e
    rl d
    jr NC,return_positive
    jr return_negative

