;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 expanded 32-bit mantissa multiply (NR inv / accurate poly path).
;
; Unpacked: B=exp, C[7]=sign, DEHL=32-bit mant (hidden 1). Same as Z80.
;
; m32_fsmul32x32
;   enter: Y in B/C/DEHL
;          stack = X.hl, X.de, X.bc, ret
;          (caller: push bc; push de; push hl of X)
;   exit:  product B/C/DEHL; X removed
;
; m32_fsmul24x32
;   enter: Y in B/C/DEHL
;          stack = IEEE X.HL, X.DE, ret
;          (caller: push de; push hl of IEEE DEHL)
;   exit:  product B/C/DEHL; X removed
;
; Kernel m32_mulu_32h_32x32:
;   DEHL=x; stack ret,y.HL,y.DE → DEHL high32; y removed
;
; Shared body frame (mul_body):
;   SP+0  Y.hl
;   SP+2  Y.de
;   SP+4  Y.bc
;   SP+6  ret
;   SP+8  X.hl
;   SP+10 X.de
;   SP+12 X.bc
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_mulu_32h_32x32

PUBLIC m32_fsmul24x32, m32_fsmul32x32


;=======================================================================
; IEEE X on stack → expand in place → mul_body
;
; Strategy: park Y, load+expand IEEE X, rebuild a clean
; Y|ret|X frame on top of the old stack, then raise SP over junk.
;=======================================================================
.m32_fsmul24x32
    ; Y in BCDEHL; SP: ret, X.HL, X.DE
    push bc
    push de
    push hl
    ; SP: Yhl Yde Ybc ret X.HL X.DE   (12)

    ; Load IEEE X
    ld de,sp+8
    ld hl,(de)
    push hl
    ld de,sp+12
    ld hl,(de)
    ex de,hl
    pop hl                          ; DEHL = IEEE X

    ; Unpack
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

    ; ---- Build clean frame on top: push X, ret, Y ----
    ; Depth tracking from entry push Y (12) + load temps that net 0:
    ;   push X (18) + push ret (20) + push Y (26)
    ; Top 14 bytes = Y|ret|X; junk = 12 (shadow Y + ret0 + ieee).
    push bc
    push de
    push hl
    ; SP: Xhl Xde Xbc Yhl Yde Ybc ret X.HL X.DE   (18)

    ; ret @ SP+12 → push
    ld de,sp+12
    ld hl,(de)
    push hl
    ; SP: ret Xhl Xde Xbc Yhl Yde Ybc ret0 ieee   (20)

    ; Y @ SP+8 → push then reverse to Yhl Yde Ybc
    ld de,sp+8
    ld hl,(de)
    push hl                         ; Yhl
    ld de,sp+12
    ld hl,(de)
    push hl                         ; Yde
    ld de,sp+16
    ld hl,(de)
    push hl                         ; Ybc
    pop bc                          ; Ybc
    pop de                          ; Yde
    pop hl                          ; Yhl
    push bc
    push de
    push hl                         ; SP top→: Yhl Yde Ybc ret X...
    ; SP: Yhl Yde Ybc ret Xhl Xde Xbc | Y0 ret0 ieee   (26)
    ; Copy 14-byte frame up by 12 (dest overlaps src by 2 — copy high→low).
    ld hl,13
    add hl,sp
    ld de,hl
    ld hl,12+13
    add hl,sp                       ; HL → last byte of dest
    ld b,14
.m24_mv
    ld a,(de)
    ld (hl),a
    dec de
    dec hl
    dec b
    jp NZ,m24_mv
    ld hl,12
    add hl,sp
    ld sp,hl                        ; SP: Yhl Yde Ybc ret Xhl Xde Xbc
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
    ld de,sp+4
    ld a,(de)                       ; Y.c
    ld hl,12
    add hl,sp
    xor (hl)                        ; X.c
    ld c,a

    ; exponent
    ld hl,13
    add hl,sp
    ld a,(hl)                       ; X.exp
    or a
    jp Z,mulzero

    sub 07fh
    jp C,fmchkuf

    ld hl,5
    add hl,sp
    add a,(hl)                      ; Y.exp
    jp C,mulovl
    jp fmnouf

.fmchkuf
    ld hl,5
    add hl,sp
    add a,(hl)
    jp NC,mulzero

.fmnouf
    or a
    jp Z,mulzero
    ld b,a
    push bc                         ; es ; SP: es Yhl Yde Ybc ret Xhl Xde Xbc

    ; mulu: DEHL=X, push y.DE, push y.HL
    ld de,sp+10
    ld hl,(de)                      ; X.hl
    push hl
    ld de,sp+14
    ld hl,(de)                      ; X.de
    ex de,hl
    pop hl                          ; DEHL = X

    push de
    push hl                         ; save X ; SP: Xhl Xde es Yhl Yde Ybc ret X...

    ; y.DE @ SP+8, y.HL @ SP+6
    ld de,sp+8
    ld hl,(de)
    push hl                         ; y.DE
    ld de,sp+8
    ld hl,(de)
    push hl                         ; y.HL

    ; restore X to DEHL
    ld de,sp+4
    ld hl,(de)
    push hl
    ld de,sp+8
    ld hl,(de)
    ex de,hl
    pop hl

    call m32_mulu_32h_32x32
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

    ; product → X slot @ SP+14
    ld de,sp+0
    ld hl,14
    add hl,sp
    ld b,6
.cp
    ld a,(de)
    ld (hl),a
    inc de
    inc hl
    dec b
    jp NZ,cp

    ; drop es ml mh Y (12) → SP: ret es ml mh
    ld hl,12
    add hl,sp
    ld sp,hl

    pop hl                          ; ret
    pop bc                          ; es
    pop de                          ; ml
    ex (sp),hl                      ; HL=mh, (sp)=ret
    ex de,hl                        ; DE=mh, HL=ml
    ret
