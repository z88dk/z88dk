;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fspoly — Horner via expanded 32-bit mantissa mul/add.
; Same algorithm as Z80 f32_fspoly.asm (no exx / af').
;
; float polyf(float x, float d[], uint16_t n)
; {
;   float res = d[n];
;   while (n)
;       res = res * x + d[--n];
;   return res;
; }
;
; sccz80 callee stack on entry:
;   SP = ret, n(2), dptr(2), x.HL(2), x.DE(2)
;
; Expanded res lives in B/C/DEHL.  ld de,sp+* clobbers DE, so park the
; full res (or at least DE) before any stack-pointer math.  BC is live
; meta — do not ld bc,de to park DE.  The Z80 path uses exx.
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul24x32
EXTERN m32_fsadd24x32

PUBLIC m32_fspoly_callee
PUBLIC _m32_polyf


._m32_polyf
.m32_fspoly_callee
    ; SP: ret, n, dptr, x.HL, x.DE

    ld de,sp+2
    ld a,(de)
    ld c,a                          ; n (temp; expand overwrites C)

    ld de,sp+4
    ld hl,(de)                      ; dptr

    ld a,c
    add a,a
    add a,a
    ld e,a
    ld d,0
    add hl,de                       ; &d[n]

    call load_expand_ieee           ; BC DEHL = expand(d[n])

.fep0
    ; test n without destroying mantissa DE
    push de
    ld de,sp+4
    ld a,(de)
    or a
    jp NZ,fep_iter
    pop de
    jp fep1

.fep_iter
    dec a
    ld (de),a                       ; --n
    pop de                          ; restore mant DE

    ; ---- res *= x (Y in BC DEHL; IEEE x copied onto the stack) ----
    push hl
    push de                         ; +0 Y.de +2 Y.hl +4 ret +6 n +8 dptr +10 xHL +12 xDE
    ld de,sp+12
    ld hl,(de)
    push hl                         ; x.DE; x.HL slides to +12
    ld de,sp+12
    ld hl,(de)
    push hl                         ; x.HL
    ; +0 xHL +2 xDE +4 Y.de +6 Y.hl
    ld de,sp+4
    ld hl,(de)
    push hl
    ld de,sp+8
    ld hl,(de)
    pop de                          ; DEHL = Y.mant; BC still meta
    call m32_fsmul24x32             ; in Y, stack x; out BCDEHL = Y*x expanded
    pop af
    pop af                          ; drop Y.de Y.hl

    ; ---- res += d[n] ----
    push hl
    push de                         ; park product mant; BC stays
    ; +0 P.de +2 P.hl +4 ret +6 n +8 dptr
    ld de,sp+6
    ld a,(de)                       ; n
    ld de,sp+8
    ld hl,(de)                      ; dptr
    add a,a
    add a,a
    ld e,a
    ld d,0
    add hl,de                       ; &d[n]
    ; IEEE push, BC preserved
    ld de,(hl+)
    push de                         ; LSW
    ld e,(hl+)
    ld d,(hl)                       ; MSW
    pop hl
    push de                         ; X.DE
    push hl                         ; X.HL
    ; +0 xHL +2 xDE +4 P.de +6 P.hl
    ld de,sp+4
    ld hl,(de)
    push hl
    ld de,sp+8
    ld hl,(de)
    pop de                          ; DEHL = product.mant; BC still meta
    call m32_fsadd24x32             ; in product, stack d[n]; out Y = res+d[n]
    pop af
    pop af                          ; drop P.de P.hl
    jp fep0

.fep1
    ; pack expanded → IEEE DEHL (IEEE RNE on residual)
    ld a,l
    ld l,h
    ld h,e
    ld e,d                          ; A=residual, EHL=top24
    ; IEEE RNE: G=bit7, S=bits6..0 (via add a,a), B=L.0
    add a,a
    jp NC,fep2                      ; G=0
    jp NZ,fep_up                    ; G=1 S≠0 → up
    ld a,l
    and 01h
    jp Z,fep2                       ; tie, even
.fep_up
    inc l
    jp NZ,fep2
    inc h
    jp NZ,fep2
    inc e
    jp NZ,fep2
    ld h,0                          ; mant overflow → 1.0, exp++ (E=0; pack discards implicit 1)
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

    pop bc                          ; ret
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp                          ; drop n, dptr, x
    push bc
    or a
    ret


;-----------------------------------------------------------------------
; load_expand_ieee
;   HL → IEEE float in memory (LSW first)
;   exit: B=exp, C[7]=sign, DEHL=32-bit mant
;-----------------------------------------------------------------------
.load_expand_ieee
    ld de,(hl+)
    push de
    ld e,(hl+)
    ld d,(hl)                       ; last word: no trailing post-inc (HL discarded)
    pop hl                          ; DEHL IEEE
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
