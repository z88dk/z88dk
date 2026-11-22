;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; gbz80 m32_fspoly — Horner via expanded 32-bit mantissa mul/add.
;-------------------------------------------------------------------------
;
; Same algorithm as 8085.  Park DE (not BC) before ld hl,sp+n.

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul24x32
EXTERN m32_fsadd24x32

PUBLIC m32_fspoly_callee
PUBLIC _m32_polyf


._m32_polyf
.m32_fspoly_callee
    ; SP: ret, n, dptr, x.HL, x.DE

    ld hl,sp+2
    ld c,(hl)                       ; n

    ld hl,sp+4
    ld a,(hl+)
    ld h,(hl)
    ld l,a                          ; dptr

    ld a,c
    add a,a
    add a,a
    ld e,a
    ld d,0
    add hl,de                       ; &d[n]

    call load_expand_ieee

.fep0
    ; 8085 parks DE only (ld de,sp+n keeps Y.hl).  Here HL is the
    ; frame pointer, so park the full mantissa first.
    push hl
    push de                         ; +0 Y.de +2 Y.hl +4 ret +6 n
    ld hl,sp+6
    ld a,(hl)
    or a
    jp NZ,fep_iter
    pop de
    pop hl
    jp fep1

.fep_iter
    dec a
    ld (hl),a                       ; --n
    pop de
    pop hl                          ; restore Y.mant

    ; ---- res *= x ----
    push hl
    push de                         ; +0 Y.de +2 Y.hl +4 ret +6 n +8 dptr +10 xHL +12 xDE
    ld hl,sp+12
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl                         ; x.DE; x.HL slides to +12
    ld hl,sp+12
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl                         ; x.HL ; +0 xHL +2 xDE +4 Y.de +6 Y.hl
    ld hl,sp+4
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl
    ld hl,sp+8
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    pop de                          ; DEHL = Y.mant; BC still meta
    call m32_fsmul24x32             ; in Y, stack x; out BCDEHL = Y*x expanded
    pop af
    pop af                          ; drop Y.de Y.hl

    ; ---- res += d[n] ----
    push hl
    push de                         ; +0 P.de +2 P.hl +4 ret +6 n +8 dptr
    ld hl,sp+6
    ld a,(hl)                       ; n
    push af
    ld hl,sp+10
    ld a,(hl+)
    ld h,(hl)
    ld l,a                          ; dptr
    pop af
    add a,a
    add a,a
    ld e,a
    ld d,0
    add hl,de                       ; &d[n]
    ld e,(hl+)
    ld d,(hl+)
    push de                         ; LSW
    ld e,(hl+)
    ld d,(hl)
    pop hl
    push de                         ; X.DE
    push hl                         ; X.HL
    ld hl,sp+4
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl
    ld hl,sp+8
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    pop de                          ; DEHL = product.mant
    call m32_fsadd24x32             ; in product, stack d[n]; out Y = res+d[n]
    pop af
    pop af                          ; drop P.de P.hl
    jp fep0

.fep1
    ld a,l
    ld l,h
    ld h,e
    ld e,d
    add a,a
    jp NC,fep2
    jp NZ,fep_up
    ld a,l
    and 01h
    jp Z,fep2
.fep_up
    inc l
    jp NZ,fep2
    inc h
    jp NZ,fep2
    inc e
    jp NZ,fep2
    ld h,0
    ld l,h
    ld e,l
    inc b
.fep2
    ld a,e
    add a,a
    ld e,a
    ld a,c
    add a,a
    ld a,b
    rra
    ld d,a
    ld a,e
    rra
    ld e,a

    pop bc
    add sp,8
    push bc
    or a
    ret


.load_expand_ieee
    ld e,(hl+)
    ld d,(hl+)
    push de
    ld e,(hl+)
    ld d,(hl)
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
    jp Z,un0
    scf
.un0
    rra
    ld d,a
    ld e,h
    ld h,l
    ld l,0
    ret
