SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sccz80_poly
EXTERN asm_f16_poly_callee

; sccz80 non-callee polyf16
;   enter (top→bottom): ret, n, d, x
;   exit: HL=result; (top→bottom): ret, pad, pad, pad
;
; Reorder to (top→bottom): x, d, n, ret then CALL callee.
; Prefer ld hl,(de) / ld (de),hl for stack word traffic.
.cm16_sccz80_poly
    ; Before: +0 ret, +2 n, +4 d, +6 x
    ; After:  +0 x,  +2 d, +4 n, +6 ret

    ld de,sp+0
    ld hl,(de)                  ; ret
    push hl                     ; temp
    ; +0 temp, +2 ret, +4 n, +6 d, +8 x
    ld de,sp+8
    ld hl,(de)                  ; x
    ld de,sp+2
    ld (de),hl                  ; ret slot ← x
    pop hl                      ; ret
    ; +0 x, +2 n, +4 d, +6 x
    ld de,sp+6
    ld (de),hl                  ; old x slot ← ret
    ; +0 x, +2 n, +4 d, +6 ret

    ; swap +2 (n) and +4 (d) via word loads/stores (no push — offsets stable)
    ld de,sp+2
    ld hl,(de)                  ; n
    ld bc,hl                    ; BC = n
    ld de,sp+4
    ld hl,(de)                  ; d
    ld de,sp+2
    ld (de),hl                  ; +2 ← d
    ld hl,bc
    ld de,sp+4
    ld (de),hl                  ; +4 ← n    ; +0 x, +2 d, +4 n, +6 ret

    call asm_f16_poly_callee
    ; leaves: ret

    pop bc
    push bc
    push bc
    push bc
    push bc
    ret
