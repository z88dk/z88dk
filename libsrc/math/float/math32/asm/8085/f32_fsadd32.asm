;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 expanded 32-bit mantissa add
; B=exp, C[7]=sign, DEHL=mant (D=MSB)
;
; m32_fsadd32x32: Y in regs; stack X.hl X.de X.bc ret
; m32_fsadd24x32: Y in regs; stack IEEE X.HL X.DE ret
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsnormalize32

PUBLIC m32_fsadd24x32, m32_fsadd32x32


;=======================================================================
.m32_fsadd24x32
    push bc
    push de
    push hl                         ; Y | ret | ieee
    ld de,sp+8
    ld hl,(de)
    push hl
    ld de,sp+12
    ld hl,(de)
    ex de,hl
    pop hl
    ld a,d
    and 080h
    ld c,a
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld b,a
    or a
    ld a,e
    jp Z,a24z
    scf
.a24z
    rra
    ld d,a
    ld e,h
    ld h,l
    ld l,0
    push bc
    push de
    push hl                         ; X | Y | ret | ieee
    ld de,sp+12
    ld hl,(de)
    push hl                         ; ret
    ld de,sp+8
    ld hl,(de)
    push hl
    ld de,sp+12
    ld hl,(de)
    push hl
    ld de,sp+16
    ld hl,(de)
    push hl
    pop bc
    pop de
    pop hl
    push bc
    push de
    push hl                         ; Y | ret | X | junk
    ld hl,13
    add hl,sp
    ld d,h
    ld e,l
    ld hl,12+13
    add hl,sp
    ld b,14
.a24c
    ld a,(de)
    ld (hl),a
    dec de
    dec hl
    dec b
    jp NZ,a24c
    ld hl,12
    add hl,sp
    ld sp,hl
    jp body


;=======================================================================
.m32_fsadd32x32
    push bc
    push de
    push hl


;=======================================================================
; SP: Yhl Yde Ybc ret Xhl Xde Xbc
;=======================================================================
.body
    ; --- sort: Y becomes larger-or-equal exp ---
    ld de,sp+5
    ld a,(de)
    ld b,a
    ld de,sp+13
    ld a,(de)
    cp b
    jp C,sorted
    jp Z,sorted
    ld hl,0
    add hl,sp
    ld d,h
    ld e,l
    ld hl,8
    add hl,sp
    ld b,6
.sw
    ld a,(de)
    ld c,a
    ld a,(hl)
    ld (de),a
    ld a,c
    ld (hl),a
    inc de
    inc hl
    dec b
    jp NZ,sw
.sorted
    ; meta: C=Y.sign, B=subflag
    ld de,sp+4
    ld a,(de)
    ld c,a
    ld hl,12
    add hl,sp
    xor (hl)
    and 080h
    ld b,a
    ld a,c
    and 080h
    ld c,a
    push bc                         ; +2  SP: meta Y ret X

    ; yexp
    ld de,sp+7
    ld a,(de)
    ld l,a
    ld h,0
    push hl                         ; +2  SP: yexp meta Y ret X

    ; diff = Y.exp - X.exp
    ; layout: 0 yexp 2 meta 4 Yhl 6 Yde 8 Ybc 10 ret 12 Xhl 14 Xde 16 Xbc
    ld de,sp+0
    ld a,(de)
    ld b,a
    ld de,sp+17
    ld a,(de)
    ld c,a
    ld a,b
    sub c
    ld l,a
    ld h,0
    push hl                         ; +2  SP: diff yexp meta Y ret X
    ; 0 diff 2 yexp 4 meta 6 Yhl 8 Yde 10 Ybc 12 ret 14 Xhl 16 Xde 18 Xbc

    ; small = X mant
    ld de,sp+14
    ld hl,(de)
    push hl
    ld de,sp+18
    ld hl,(de)
    ex de,hl
    pop hl                          ; DEHL = small
    pop bc
    ld a,c                          ; A = diff
    ; SP: yexp meta Y ret X

    or a
    jp Z,al0
    cp 24
    jp NC,ret_y
.alp
    push af
    call srl1
    pop af
    dec a
    jp NZ,alp
.al0
    ; DEHL = small. Save small, load large, add.
    push de                         ; small.DE
    push hl                         ; small.HL  top
    ; load large Y mant: Y at sp+8 after 4 bytes small
    ld de,sp+8
    ld a,(de)
    ld l,a
    inc de
    ld a,(de)
    ld h,a                          ; HL = Y.hl
    inc de
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a                          ; BC = Y.de
    ; large DEHL: DE=Y.de=BC, HL=Y.hl
    push hl
    ld d,b
    ld e,c
    pop hl                          ; DEHL = large
    ; sub flag at sp+7 — do not clobber DE
    push de
    ld de,sp+9                      ; +2 for push de; meta.sub
    ld a,(de)
    pop de
    or a
    jp NZ,subm
    ; small on stack: top HL, then DE
    pop bc                          ; small.HL
    add hl,bc
    pop bc                          ; small.DE
    ld a,e
    adc a,c
    ld e,a
    ld a,d
    adc a,b
    ld d,a
    jp NC,add_done
    scf
    call rrc
    jp NC,add_sticky
    ld a,l
    or 1
    ld l,a
.add_sticky
    push de
    ld de,sp+2
    ld a,(de)
    inc a
    jp Z,ovf_de
    ld (de),a
    pop de
    jp add_done

.ovf_de
    pop de
    jp ovf

.add_done
    jp fin

.subm
    ; SP: sml smh yexp meta Y… and DEHL was large — broken if entered; re-fetch
    pop bc
    or a
    sbc hl,bc
    pop bc
    ld a,e
    sbc a,c
    ld e,a
    ld a,d
    sbc a,b
    ld d,a
    jp NC,sub_ok
    call neg
    ld de,sp+2
    ld a,(de)
    xor 080h
    ld (de),a
.sub_ok
    ld a,d
    or e
    or h
    or l
    jp Z,zero
    ld a,d
    and 080h
    jp NZ,fin
    push de
    push hl
    ld de,sp+4
    ld a,(de)
    ld b,a
    ld de,sp+6
    ld a,(de)
    and 080h
    ld c,a
    pop hl
    pop de
    call m32_fsnormalize32
    jp drop_tm

.fin
    push de
    push hl
    ld de,sp+4
    ld a,(de)
    ld b,a
    ld de,sp+6
    ld a,(de)
    and 080h
    ld c,a
    pop hl
    pop de
    jp drop_tm

.ret_y
    ; SP: yexp meta Y ret X
    pop bc
    pop bc
    ld de,sp+4
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    ld de,sp+0
    ld hl,(de)
    push hl
    ld de,sp+4
    ld hl,(de)
    ex de,hl
    pop hl
    jp ep_yx

.zero
    pop bc
    pop bc
    ld b,0
    ld c,0
    ld de,0
    ld hl,0
    jp ep_yx

.ovf
    pop bc
    pop bc
    ld b,0ffh
    ld c,0
    ld de,08000h
    ld hl,0
    jp ep_yx

; BC DEHL result; SP: yexp meta Y ret X
.drop_tm
    push de
    push hl
    push bc                         ; res(6) yexp meta Y ret X
    ld de,sp+0
    ld hl,10
    add hl,sp
    ld b,6
.dcp
    ld a,(de)
    ld (hl),a
    inc de
    inc hl
    dec b
    jp NZ,dcp
    ld hl,10
    add hl,sp
    ld sp,hl                        ; Y'=res ret X
    pop bc
    pop hl
    pop de

; BC DEHL result; SP: Y ret X  (or ret X if Y already consumed — here Y gone means SP: ret X)
; After pop*3 from Y'=res: SP is ret X
    push de
    push hl
    push bc                         ; res ret X
    ld de,sp+0
    ld hl,8
    add hl,sp
    ld b,6
.ecp
    ld a,(de)
    ld (hl),a
    inc de
    inc hl
    dec b
    jp NZ,ecp
    ld hl,6
    add hl,sp
    ld sp,hl                        ; ret X'=res
    pop hl
    pop bc
    pop de
    ex (sp),hl
    ex de,hl
    ret

; BC DEHL result; SP: Y ret X
.ep_yx
    push de
    push hl
    push bc                         ; res Y ret X
    ld de,sp+0
    ld hl,14
    add hl,sp
    ld b,6
.fcp
    ld a,(de)
    ld (hl),a
    inc de
    inc hl
    dec b
    jp NZ,fcp
    ld hl,12
    add hl,sp
    ld sp,hl                        ; ret es ml mh
    pop hl
    pop bc
    pop de
    ex (sp),hl
    ex de,hl
    ret


.srl1
    xor a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ret NC
    ld a,l
    or 1
    ld l,a
    ret

.rrc
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ret

.neg
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
    inc l
    ret NZ
    inc h
    ret NZ
    inc e
    ret NZ
    inc d
    ret
