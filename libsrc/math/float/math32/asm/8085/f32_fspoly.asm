;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fspoly — Horner polynomial evaluation
;   res = d[n]; while(n) res = res * x + d[--n];
; Stack only (no BSS). Uses fsmul/fsadd callees (IEEE).
;
; enter: stack (top→) ret, x.LSW, x.MSW, dptr.lo, dptr.hi, n.lo, n.hi
; exit:  DEHL = result
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul_callee
EXTERN m32_fsadd_callee

PUBLIC m32_fspoly_callee
PUBLIC _m32_polyf


._m32_polyf
.m32_fspoly_callee
    ; SP: ret, x(4), dptr(2), n(2)
    pop bc                          ; BC = ret
    pop hl                          ; x LSW
    pop de                          ; x MSW
    ; SP: dptr, n
    push de
    push hl                         ; save x
    push bc                         ; save ret
    ; SP: ret, x(4), dptr, n
    ;
    ; Frame offsets:
    ;   +0 ret
    ;   +2 x LSW
    ;   +4 x MSW
    ;   +6 dptr
    ;   +8 n

    ; ---- res = d[n] ----
    ld de,sp+8
    ld a,(de)
    push af                         ; save n (A) on stack
    ; SP: n_byte, ret, x, dptr, n_word
    ; dptr now at +8, index in A (still)
    ld de,sp+8
    ld a,(de)
    ld l,a
    inc de
    ld a,(de)
    ld h,a                          ; HL = dptr
    pop af                          ; A = n again
    push af                         ; keep n on stack
    ; HL = dptr, A = n; form &d[n]
    ld c,a
    ld b,0
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc                       ; HL = dptr + 4*n
    call load_float_hl              ; DEHL = d[n] = res
    pop bc                          ; B = n

.poly_loop
    ld a,b
    or a
    jp Z,poly_done
    dec b
    push bc                         ; save n (B)
    ; res * x
    push de
    push hl                         ; left = res
    ; SP: res(4), n_save(2), ret(2), x(4), dptr(2), n_word
    ; x LSW at +8
    ld de,sp+8
    call load_float_de              ; DEHL = x
    call m32_fsmul_callee           ; DEHL = res*x
    ; + d[n]
    push de
    push hl                         ; left = product
    ; SP: prod(4), n_save(2), ret(2), x(4), dptr(2), n_word
    ; dptr at +12
    ld de,sp+12
    ld a,(de)
    ld l,a
    inc de
    ld a,(de)
    ld h,a                          ; HL = dptr
    ld de,sp+5
    ld a,(de)                       ; B of n_save = current n
    ld c,a
    ld b,0
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    call load_float_hl              ; DEHL = d[n]
    call m32_fsadd_callee
    pop bc                          ; B = n
    jp poly_loop

.poly_done
    ; DEHL = res
    ; SP: ret, x, dptr, n_word
    pop bc                          ; ret
    pop af
    pop af                          ; x
    pop af                          ; dptr
    pop af                          ; n_word
    push bc
    or a                            ; clear carry
    ret


; load IEEE float at address DE into DEHL
.load_float_de
    push de
    pop hl
; load IEEE float at address HL into DEHL
.load_float_hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld h,b
    ld l,c                          ; DEHL = MSW|LSW
    ret
