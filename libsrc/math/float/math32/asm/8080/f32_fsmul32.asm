;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; 8080 expanded 32-bit mantissa multiply (NR inv / accurate poly path).
;-------------------------------------------------------------------------
;
; Unpacked: B=exp, C[7]=sign, DEHL=32-bit mant (hidden 1). Same as 8085.
;
; Frame: ld hl,sp+n, ld a,(hl+), ld (hl+),e / ld (hl),d.
; No ld de,sp+*, ld hl,(de), or exx.

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_mulu_32h_32x32

PUBLIC m32_fsmul24x32, m32_fsmul32x32


;=======================================================================
; IEEE X on stack → expand → mul_body frame Y|ret|X
; Same in-place expand + 7-word left rotate as 8085 (strategy D).
;=======================================================================
.m32_fsmul24x32
    ; Y in BCDEHL; SP: ret, X.HL, X.DE
    push bc
    push de
    push hl
    ; SP: Yhl Yde Ybc ret X.HL X.DE   (12)

    ld hl,sp+8
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl
    ld hl,sp+12
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ex de,hl
    pop hl                          ; DEHL = IEEE X

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
    jp Z,m24_nh
    scf
.m24_nh
    rra
    ld d,a
    ld e,h
    ld h,l
    ld l,0                          ; BC DEHL = expanded X

    ; ieee(4) → X.hl|X.de; grow +2 with X.bc; rotate to Y|ret|X
    push de                         ; save X.de
    ex de,hl                        ; DE = X.hl
    ld hl,sp+10                     ; ieee.HL after push
    ld (hl+),e
    ld (hl),d                       ; X.hl
    pop de                          ; X.de
    ld hl,sp+10
    ld (hl+),e
    ld (hl),d                       ; X.de
    ; SP: Y ret X.hl X.de (12); BC = X.bc

    push bc                         ; SP: X.bc Yhl Yde Ybc ret X.hl X.de  (14)
    ; Left-rotate 7 words by 1 → Yhl Yde Ybc ret X.hl X.de X.bc
    ld hl,sp+0
    ld c,(hl+)
    ld b,(hl)                       ; BC = old w0 (X.bc)

    ld hl,sp+2
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+0
    ld (hl+),e
    ld (hl),d                       ; w0 = Yhl

    ld hl,sp+4
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+2
    ld (hl+),e
    ld (hl),d                       ; w1 = Yde

    ld hl,sp+6
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+4
    ld (hl+),e
    ld (hl),d                       ; w2 = Ybc

    ld hl,sp+8
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+6
    ld (hl+),e
    ld (hl),d                       ; w3 = ret

    ld hl,sp+10
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+8
    ld (hl+),e
    ld (hl),d                       ; w4 = X.hl

    ld hl,sp+12
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+10
    ld (hl+),e
    ld (hl),d                       ; w5 = X.de

    ld hl,sp+12
    ld (hl+),c
    ld (hl),b                       ; w6 = X.bc

    ; SP: Yhl Yde Ybc ret Xhl Xde Xbc
    jp mul_body


;=======================================================================
.m32_fsmul32x32
    push bc
    push de
    push hl
    ; SP: Yhl Yde Ybc ret Xhl Xde Xbc
    jp mul_body


;=======================================================================
; SP: Yhl Yde Ybc ret Xhl Xde Xbc
;=======================================================================
.mul_body
    ; sign
    ld hl,sp+4
    ld a,(hl)                       ; Y.c
    ld hl,sp+12
    xor (hl)                        ; X.c
    ld c,a

    ; exponent
    ld hl,sp+13
    ld a,(hl)                       ; X.exp
    ; ±0 is classified by the IEEE caller (fsmul / inv / sqrt / poly)
    sub 07fh
    jp C,fmchkuf

    ld hl,sp+5
    add a,(hl)                      ; Y.exp
    jp C,mulovl
    jp fmnouf

.fmchkuf
    ld hl,sp+5
    add a,(hl)
    jp NC,mulzero

.fmnouf
    or a
    jp Z,mulzero
    ld b,a
    push bc                         ; es ; SP: es Yhl Yde Ybc ret Xhl Xde Xbc

    ; mulu: DEHL=X, push y.DE, push y.HL
    ld hl,sp+10
    ld a,(hl+)
    ld h,(hl)
    ld l,a                          ; X.hl
    push hl
    ld hl,sp+14
    ld a,(hl+)
    ld h,(hl)
    ld l,a                          ; X.de
    ex de,hl
    pop hl                          ; DEHL = X

    push de
    push hl                         ; save X ; SP: Xhl Xde es Yhl Yde Ybc ret X...

    ; y.DE @ SP+8, y.HL @ SP+6
    ld hl,sp+8
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl                         ; y.DE
    ld hl,sp+8
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl                         ; y.HL

    ; restore X to DEHL
    ld hl,sp+4
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl
    ld hl,sp+8
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ex de,hl
    pop hl

    call m32_mulu_32h_32x32         ; in stack X,Y 32-bit mants; out DEHL=high 32
    ; DEHL = product; SP: Xhl Xde es Yhl Yde Ybc ret Xhl Xde Xbc

    pop bc                          ; drop Xhl
    pop bc                          ; drop Xde
    pop bc                          ; BC = es

    ld a,d
    and 080h
    jp NZ,fm0
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,d
    rla
    ld d,a
    jp epilogue

.fm0
    inc b
    jp NZ,epilogue
    ld b,0ffh
    ld de,0
    ld hl,0
    jp epilogue

.mulzero
    ld b,0
    ld de,0
    ld hl,0
    jp epilogue

.mulovl
    ld b,0ffh
    ld de,0
    ld hl,0

;-----------------------------------------------------------------------
; BC DEHL = product; SP: Yhl Yde Ybc ret Xhl Xde Xbc
;-----------------------------------------------------------------------
.epilogue
    push de
    push hl
    push bc
    ; SP: es ml mh Yhl Yde Ybc ret Xhl Xde Xbc

    ld hl,sp+0
    ld de,hl                        ; DE = src
    ld hl,14
    add hl,sp                       ; HL = dest X slot
    ld b,6
.cp
    ld a,(de)
    ld (hl),a
    inc de
    inc hl
    dec b
    jp NZ,cp

    ld hl,12
    add hl,sp
    ld sp,hl

    pop hl                          ; ret
    pop bc                          ; es
    pop de                          ; ml
    ex (sp),hl                      ; HL=mh, (sp)=ret
    ex de,hl                        ; DE=mh, HL=ml
    ret
