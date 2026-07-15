
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_discardfraction

; Entry: dehl = 32 bit float
; Exit:  dehl = 32 bit float without fractional part
;        NC = already integer (result equals input)
;        C  = fractional part was discarded

.m32_discardfraction
    rl de                       ; get the exponent
    jr Z,zero_legal             ; exp 0 -> signed zero, NC

    ld a,d                      ; Exponent
    rr de                       ; Keep sign and exponent safe
    sub $7f                     ; Exponent value of 127 is 1.xx
    jr C,return_zero            ; |x| < 1 -> signed zero, C

    inc a
    cp 24
    jr C,mask_frac
    or a                        ; |x| >= 2^23: already integer, NC
    ret

.mask_frac
    push de                     ; save original
    push hl

    exx                         ; Build mask of integer bits
    ld hl,0                     ; a = number of bits to keep
    ld e,h

.shift_right                    ; shift mantissa mask right
    scf
    rr e
    rr hl
    dec a
    jr NZ,shift_right

    ld  a,e                     ; mask out fractional bits
    exx
    and e
    ld  e,a
    ld  a,h
    exx
    and h
    exx
    ld h,a
    ld a,l
    exx
    and l
    exx
    ld l,a                      ; dehl = truncated

    pop bc                      ; orig L
    ld a,l
    cp c
    jr NZ,changed_pop
    ld a,h
    cp b
    jr NZ,changed_pop
    pop bc                      ; orig H
    ld a,e
    cp c
    jr NZ,changed
    ld a,d
    cp b
    jr NZ,changed
    or a                        ; identical -> NC
    ret

.changed_pop
    pop bc                      ; drop orig H
.changed
    scf
    ret

.return_zero
    rl d                        ; Get the sign bit
    ld d,0
    ld e,d
    ld hl,de
    rr d
    scf                         ; nonzero |x|<1 -> C
    ret

.zero_legal
    ld e,d                      ; use 0
    ld hl,de
    rr d                        ; restore the sign
    or a                        ; NC
    ret                         ; return IEEE signed ZERO in DEHL
