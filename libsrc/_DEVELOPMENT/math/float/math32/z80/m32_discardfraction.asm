


SECTION code_fp_math32
PUBLIC m32_discardfraction

; Entry: dehl = 32 bit float
; Exit:  dehl = 32 bit float without fractional part
m32_discardfraction:
    ; Grab the exponent
    push de
    sla e                       ; get the exponent
    rl d
    jr Z,zero_legal             ; return IEEE signed zero
    ld a,d			; Exponent
    rr e			; Keep sign safe
    pop de
    ; Exponent value of 127 is 1
    sub $7e
    jr  z,return_zero
    cp  24
    ret nc			; No shift needed, all integer
    				; a = number of bits to clear
    exx
    ld e,0
    ld hl,0
 shift_right:
    scf
    rr e
    rr h
    rr l
    dec a
    jr  nz,shift_right
    ld  a,e
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
    ld l,a
    ret


return_zero:
    push de			;Just to equalise stack
    ; Get the sign bit
    rl d
    ld d,0
.zero_legal
    pop bc			; Discard saved MSW
    ld e,d                      ; use 0
    ld h,d
    ld l,d
    rr d                        ; restore the sign
    ret                         ; return IEEE signed ZERO in DEHL
