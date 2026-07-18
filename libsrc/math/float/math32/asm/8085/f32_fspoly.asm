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
; full res (or at least DE) before any stack-pointer math.  The Z80 path
; uses exx for the same reason.
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

    ; ---- res *= x (Y=res in regs; IEEE x on stack) ----
    push bc
    push de
    push hl                         ; park res
    ; SP: Rhl Rde Rbc ret n dptr xHL xDE
    ;     0   2   4   6   8 10   12  14

    ld de,sp+14
    ld hl,(de)                      ; x.DE
    push hl
    ld de,sp+14
    ld hl,(de)                      ; x.HL
    push hl
    ; SP: xHL xDE Rhl Rde Rbc ret n dptr xHL xDE
    ;     0   2   4   6   8  10 12 14  16  18

    ; restore res into BC DEHL (inline — no call, no extra ret word)
    ld de,sp+4
    ld hl,(de)
    push hl
    ld de,sp+8
    ld hl,(de)
    push hl
    ld de,sp+12
    ld hl,(de)
    push hl
    pop bc
    pop de
    pop hl

    call m32_fsmul24x32             ; product; SP: Rhl Rde Rbc ret n dptr x
    pop af
    pop af
    pop af                          ; drop parked res

    ; ---- res += d[n] ----
    push bc
    push de
    push hl                         ; park product
    ; SP: Phl Pde Pbc ret n dptr x
    ;     0   2   4   6  8  10  12

    ld de,sp+10
    ld hl,(de)                      ; dptr
    ld de,sp+8
    ld a,(de)                       ; n
    add a,a
    add a,a
    ld e,a
    ld d,0
    add hl,de                       ; &d[n]
    call load_ieee_push
    ; SP: xHL xDE Phl Pde Pbc ret n dptr x
    ;     0   2   4   6   8  10 12 14  16

    ; restore product into BC DEHL (inline)
    ld de,sp+4
    ld hl,(de)
    push hl
    ld de,sp+8
    ld hl,(de)
    push hl
    ld de,sp+12
    ld hl,(de)
    push hl
    pop bc
    pop de
    pop hl

    call m32_fsadd24x32             ; sum; SP: Phl Pde Pbc ret n dptr x
    pop af
    pop af
    pop af                          ; drop parked product
    jp fep0

.fep1
    ; pack expanded → IEEE DEHL
    ld a,l
    ld l,h
    ld h,e
    ld e,d
    and 080h
    jp Z,fep2
    ld a,l
    or 1
    ld l,a
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
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push de
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
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


;-----------------------------------------------------------------------
; load_ieee_push
;   HL → IEEE float; push MSW then LSW (for fsmul24x32 / fsadd24x32).
;   Return address is moved above the pushed float so ret is safe.
;-----------------------------------------------------------------------
.load_ieee_push
    pop bc                          ; ret
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push de                         ; LSW temp
    ld e,(hl)
    inc hl
    ld d,(hl)                       ; MSW
    pop hl                          ; LSW
    push de                         ; MSW  → X.DE
    push hl                         ; LSW  → X.HL
    push bc                         ; ret
    ret
