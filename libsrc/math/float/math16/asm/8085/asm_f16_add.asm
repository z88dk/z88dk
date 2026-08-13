;
;  feilipu, 2020 May / 2026 July (8085)
;-------------------------------------------------------------------------
;  asm_f16_add
;-------------------------------------------------------------------------
; Entry (sccz80 callee): HL = y, stack = [uret][x]
; Exit: HL = half result; x consumed; uret restored
;
; f24_add_f24 CALL: [cret][X.hl][X.de], Y in DEHL
; Frame after setup:    [cret][Y.hl][Y.de][X.hl][X.de]
;
; 8085: no exx. Sort large/small by dual-path loads (no stack swap4).
; Working pushes: [large.mant][large.de] on top of the frame.
; Align small mantissa with byte (≥8) + bit shifts.
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_inf
EXTERN asm_f24_nan
EXTERN asm_f24_normalize

PUBLIC asm_f16_add_callee
PUBLIC asm_f16_sub_callee
PUBLIC asm_f24_add_callee
PUBLIC asm_f24_sub_callee
PUBLIC asm_f24_add_f24

;--------------------------------------------------------------------
.asm_f16_sub_callee
    ld a,h
    xor 080h
    ld h,a

.asm_f16_add_callee
    ; HL=y, stack=[uret][x]
    ; Add is commutative: leave y on stack as f24_add's X, x in DEHL as Y.
    call asm_f24_f16            ; y → f24
    push de
    push hl                     ; [y.hl][y.de][uret][x]
    ld de,sp+6
    ld hl,(de)                  ; x half
    call asm_f24_f16            ; x → f24 in DEHL
    call asm_f24_add_f24        ; drops y; leaves [uret][x]
    pop bc                      ; uret
    pop af                      ; consume x
    push bc
    jp asm_f16_f24

;--------------------------------------------------------------------
.asm_f24_sub_callee
    ld a,e
    xor 080h
    ld e,a

.asm_f24_add_callee
.asm_f24_add_f24
    ; CALL: [cret][X.hl][X.de], Y in DEHL
    pop bc                      ; cret
    push de
    push hl
    push bc                     ; [cret][Y.hl][Y.de][X.hl][X.de]

    ; ---- specials gate (f24 exp 255) ----
    ; Frame: [cret][Y.hl][Y.de][X.hl][X.de]; de word L=sign H=exp.
    ;   NaN ± * → NaN;  Inf ± finite → Inf;  Inf−Inf → NaN
    ld de,sp+4
    ld hl,(de)
    ld a,h
    inc a
    jp Z,hadd_spec_y
    ld de,sp+8
    ld hl,(de)
    ld a,h
    inc a
    jp Z,hadd_spec_x

    ; Y.de @+4 (L=sign,H=exp), X.de @+8
    ld de,sp+4
    ld hl,(de)
    ld bc,hl                    ; Y.exp
    ld de,sp+8
    ld hl,(de)
    ld a,h                      ; X.exp
    cp b
    jp C,y_large                ; X.exp < Y.exp → Y large

    ; ---- X large (or equal exp) ----
    sub b                       ; expdiff
    cp 16
    jp NC,pack_x
    ld b,a                      ; B = expdiff
    ld a,l                      ; X.sign
    xor c
    and 080h
    ld c,a                      ; C = subflag
    push hl                     ; large.de = X.de (L=sign H=exp)
    ld de,sp+8                  ; X.hl @+6 → +8 after push
    ld hl,(de)
    push hl                     ; large.mant
    ld de,sp+6                  ; Y.hl @+2 → +6 after two pushes
    ld hl,(de)                  ; small = Y.mant
    ld a,b
    jr align_add

.y_large
    ; ---- Y large ----
    ld a,b
    sub h                       ; expdiff
    cp 16
    jp NC,pack_y
    ld b,a
    ld a,c                      ; Y.sign
    xor l
    and 080h
    ld c,a                      ; C = subflag
    ld de,sp+4
    ld hl,(de)                  ; Y.de
    push hl                     ; large.de
    ld de,sp+4                  ; Y.hl @+2 → +4 after push
    ld hl,(de)
    push hl                     ; large.mant
    ld de,sp+10                 ; X.hl @+6 → +10 after two pushes
    ld hl,(de)                  ; small = X.mant
    ld a,b

; A=expdiff, C=subflag, HL=small
; stack: [l.mant][l.de][cret][Y.hl][Y.de][X.hl][X.de]
.align_add
    or a
    jp Z,got_small

.algn
    cp 8
    jr C,algn_bits
    sub 8
    ld b,a                      ; remaining (C = subflag preserved)
    ld a,l
    or a
    ld l,h
    ld h,0
    jr Z,algn_more
    ld a,l
    or 1
    ld l,a
.algn_more
    ld a,b
    or a
    jp Z,got_small
    jr algn

.algn_bits
    ld b,a                      ; 1..7 (C = subflag still)
    ; logical srl via sra: first step must clear bit15; AND clears C
    ; so apply sticky before / without relying on C after AND.
.algn1
    sra hl                      ; C ← old bit0 (sticky)
    jp NC,al1_ns
    ld a,h
    and 07fh                    ; force logical (clears C)
    ld h,a
    ld a,l
    or 1
    ld l,a
    jr al1_done
.al1_ns
    ld a,h
    and 07fh
    ld h,a
.al1_done
    dec b
    jp Z,got_small
    ; bit15 is now 0 → bare sra ≡ logical srl; C survives for sticky
.algn_fast
    sra hl
    jp NC,al1f
    ld a,l
    or 1
    ld l,a
.al1f
    dec b
    jp NZ,algn_fast

.got_small
    pop de                      ; DE=large HL=small; [l.de][cret][Y][X]
    ld a,c
    or a
    jp NZ,do_sub

    add hl,de
    jp NC,finish_add
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    jp NC,add_ov1
    ld a,l
    or 1
    ld l,a
.add_ov1
    pop de                      ; large.de → E=sign D=exp
    inc d
    jp Z,ovf_de
    jr finish2

.finish_add
    pop de                      ; large.de
.finish2
    ; DEHL=result; stack [cret][Y.hl][Y.de][X.hl][X.de].
    ; BC gets cret → no free pair to park DEHL for SP adjust; 4×pop af
    ; (~40c) beats park+push/pop cret (~60c+).  (cf. fsmul 7-word bulk.)
    pop bc
    pop af
    pop af
    pop af
    pop af
    push bc
    ret

.do_sub
    ex de,hl                    ; HL=large DE=small
    push de
    ld bc,de                    ; BC=small (subflag no longer needed)
    or a
    sub hl,bc
    pop de
    jp C,sub_rev
    ld a,h
    or l
    jp NZ,sub_ok
    ; exact zero — DE=0, HL free for SP adjust, then HL=0
    pop af                      ; drop large.de
    ld de,0
    pop bc
    ld hl,8
    add hl,sp
    ld sp,hl
    ld hl,0
    push bc
    ret

.sub_ok
    pop de                      ; large.de
    pop bc
    pop af
    pop af
    pop af
    pop af
    push bc
    jp asm_f24_normalize

.sub_rev
    ld bc,de
    add hl,bc                   ; restore large
    ld bc,hl                    ; BC=large
    ex de,hl                    ; HL=small
    or a
    sub hl,bc
    pop de                      ; large.de
    ld a,e
    xor 080h
    ld e,a                      ; flip sign of result
    pop bc
    pop af
    pop af
    pop af
    pop af
    push bc
    jp asm_f24_normalize

.pack_y
    pop bc
    pop hl
    pop de
    pop af
    pop af
    push bc
    ret

.pack_x
    pop bc
    pop af
    pop af
    pop hl
    pop de
    push bc
    ret

.ovf_de
    ; E already has sign; HL free → ld hl,n preserves DE
    pop bc
    ld hl,8
    add hl,sp
    ld sp,hl
    push bc
    jp asm_f24_inf

    ; ---- cold specials ----
    ; f24: Inf HL=0, NaN HL≠0, exp 255 in de.H

; Y.exp == 255
.hadd_spec_y
    ld de,sp+2
    ld hl,(de)                      ; Y.mant
    ld a,h
    or l
    jp NZ,hadd_nan
    ld de,sp+8
    ld hl,(de)
    ld a,h
    inc a
    jp NZ,hadd_inf_y                ; Inf ± finite → Y Inf
    ld de,sp+6
    ld hl,(de)
    ld a,h
    or l
    jp NZ,hadd_nan                  ; X NaN
    ld de,sp+4
    ld a,(de)                       ; Y.sign
    ld b,a
    ld de,sp+8
    ld a,(de)
    xor b
    and 080h
    jp NZ,hadd_nan                  ; Inf − Inf
.hadd_inf_y
    ld de,sp+4
    ld a,(de)
    and 080h
    ld e,a
    ld d,255
    ld hl,0
    jp hadd_epi

; X.exp == 255, Y finite
.hadd_spec_x
    ld de,sp+6
    ld hl,(de)
    ld a,h
    or l
    jp NZ,hadd_nan
    ld de,sp+8
    ld a,(de)
    and 080h
    ld e,a
    ld d,255
    ld hl,0
    jp hadd_epi

.hadd_nan
    ld de,0
    ld d,255
    ld hl,04000h
.hadd_epi
    ; Same frame as finish2: cret in BC, 4× half-words under — keep pops.
    pop bc
    pop af
    pop af
    pop af
    pop af
    push bc
    ret
