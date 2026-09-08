SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sccz80_poly
EXTERN asm_f16_poly_callee

; sccz80 non-callee polyf16
;   enter (top→bottom): ret, n, d, x
;   exit: HL=result; (top→bottom): ret, pad, pad, pad
;
; Reorder to (top→bottom): x, d, n, ret then CALL callee.
; 8080: HL walks, never pop af for the return word.
.cm16_sccz80_poly
    ; Before: +0 ret, +2 n, +4 d, +6 x
    ; After:  +0 x,  +2 d, +4 n, +6 ret

    ld hl,sp+0
    ld a,(hl+)
    ld h,(hl)
    ld l,a                      ; ret
    push hl                     ; temp
    ; +0 temp, +2 ret, +4 n, +6 d, +8 x
    ld hl,sp+8
    ld a,(hl+)
    ld h,(hl)
    ld l,a                      ; x
    ex de,hl                    ; DE = x
    ld hl,sp+2
    ld a,e
    ld (hl+),a
    ld (hl),d                   ; ret slot ← x
    pop hl                      ; ret
    ; +0 x, +2 n, +4 d, +6 x
    ex de,hl                    ; DE = ret
    ld hl,sp+6
    ld a,e
    ld (hl+),a
    ld (hl),d                   ; old x slot ← ret
    ; +0 x, +2 n, +4 d, +6 ret

    ; swap +2 (n) and +4 (d)
    ld hl,sp+2
    ld a,(hl+)
    ld c,a
    ld a,(hl)
    ld b,a                      ; BC = n
    ld hl,sp+4
    ld a,(hl+)
    ld e,a
    ld a,(hl)
    ld d,a                      ; DE = d
    ld hl,sp+2
    ld a,e
    ld (hl+),a
    ld (hl),d                   ; +2 ← d
    ld hl,sp+4
    ld a,c
    ld (hl+),a
    ld (hl),b                   ; +4 ← n

    call asm_f16_poly_callee

    pop bc
    push bc
    push bc
    push bc
    push bc
    ret
