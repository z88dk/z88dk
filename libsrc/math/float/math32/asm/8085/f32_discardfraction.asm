;
; 8085 m32_discardfraction
;
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_discardfraction

.m32_discardfraction
    rl de
    jr Z,zero_legal

    ld a,d
    push af
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    pop af

    sub $7f
    jr C,return_zero

    inc a
    cp 24
    jr C,mask_frac
    or a
    ret

.mask_frac
    ld b,a                      ; n bits to keep
    ; keep original in BC and AF' impossible — use stack frame
    push de                     ; DE0
    push hl                     ; HL0
    push de                     ; DE0 again for result build
    push hl                     ; HL0 again

    ld hl,0
    ld c,0
.sr
    scf
    ld a,c
    rra
    ld c,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    dec b
    jr NZ,sr

    ; mask C:H:L ; stack HL0, DE0, HL0, DE0 (top=HL0)
    ex de,hl                    ; DE=mask15
    ld a,c                      ; A=mask23
    pop hl                      ; HL0
    ld c,a
    ld a,l
    and e
    ld l,a
    ld a,h
    and d
    ld h,a                      ; HL = new HL
    pop de                      ; DE0
    ld a,e
    and c
    ld e,a                      ; DE = new DE (D kept)
    ; stack: HL0, DE0 (originals for compare)
    pop bc                      ; BC = HL0
    ld a,l
    cp c
    jr NZ,ch_pop
    ld a,h
    cp b
    jr NZ,ch_pop
    pop bc                      ; BC = DE0
    ld a,e
    cp c
    jr NZ,ch
    ld a,d
    cp b
    jr NZ,ch
    or a                        ; NC identical
    ret

.ch_pop
    pop bc
.ch
    scf
    ret

.return_zero
    ; dehl restored float; force signed zero, C set
    ld a,d
    rla                         ; sign -> C
    ld d,0
    ld e,d
    ld hl,de
    ld a,d
    rra                         ; sign back to d7
    ld d,a
    scf
    ret

.zero_legal
    ; after rl de with exp 0: d=0, C=sign
    ld e,d
    ld hl,de
    ld a,d
    rra                         ; rr d: sign from C
    ld d,a
    or a                        ; NC
    ret
