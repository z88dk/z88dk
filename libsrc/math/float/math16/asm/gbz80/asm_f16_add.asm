;
;  feilipu, 2020 May / 2026 September (gbz80)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_add
;-------------------------------------------------------------------------
; Entry (sccz80 callee): HL = y, stack = [uret][x]
; Exit: HL = half result; x consumed; uret restored
;
; f24_add_f24 CALL: [cret][X.hl][X.de], Y in DEHL
; Frame after setup:    [cret][Y.hl][Y.de][X.hl][X.de]
;
; gbz80: no exx. Sort large/small by dual-path loads (no stack swap4).
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
    ;; x half
    ld hl,sp+6
    ld a,(hl+)
    ld h,(hl)
    ld l,a
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

    ; Specials off the finite path (adjunct).  Half Inf → f24 exp 255;
    ; half finite max → 142, so Inf±finite hits cp 16 and returns the larger.
    ; Inf±Inf / NaN only at equal-exp 255 (align_add, A=0).
    ; No S/P: never jp P / jp M.  ld hl,sp+n is native (signed; Z←0, C rewritten).

    ; Y.de @+4 (L=sign,H=exp), X.de @+8
    ld hl,sp+4
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ld bc,hl                    ; Y.exp
    ld hl,sp+8
    ld a,(hl+)
    ld h,(hl)
    ld l,a
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
    ;; X.hl @+6 → +8 after push
    ld hl,sp+8
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl                     ; large.mant
    ;; small = Y.mant
    ld hl,sp+6
    ld a,(hl+)
    ld h,(hl)
    ld l,a
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
    ;; Y.de
    ld hl,sp+4
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl                     ; large.de
    ;; Y.hl @+2 → +4 after push
    ld hl,sp+4
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl                     ; large.mant
    ;; small = X.mant
    ld hl,sp+10
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ld a,b

; A=expdiff, C=subflag, HL=small
; stack: [l.mant][l.de][cret][Y.hl][Y.de][X.hl][X.de]
.align_add
    or a
    jp NZ,algn
    ; equal exp.  Inf±Inf / NaN only if large exp is 255.
    ld b,c                      ; ld hl,sp+n forces Z=0 and rewrites C
    push hl
    ld hl,sp+4                  ; l.de
    ld a,(hl+)                  ; native (hl+) for A
    ld h,(hl)
    inc h                       ; 8-bit inc sets Z, not C: exp==255?
    pop hl
    ld c,b                      ; restore subflag
    jr NZ,got_small
    jp hadd_eq_hi

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
    set 0,l
.algn_more
    ld a,b
    or a
    jp Z,got_small
    jr algn

.algn_bits
    ld b,a                      ; 1..7 (C = subflag still)
    ; native logical 16-bit >> : srl h / rr l (C = sticky)
.algn_srl
    srl h
    rr l
    jr NC,al1f
    set 0,l
.al1f
    dec b
    jr NZ,algn_srl

.got_small
    pop de                      ; DE=large HL=small; [l.de][cret][Y][X]
    ld a,c
    or a
    jp NZ,do_sub

    add hl,de
    jp NC,finish_add
    rr h                        ; 17-bit overflow into H7
    rr l
    jr NC,add_ov1
    set 0,l
.add_ov1
    pop de                      ; large.de → E=sign D=exp
    inc d
    jp Z,ovf_de
    jr finish2

.finish_add
    pop de                      ; large.de
.finish2
    ; DEHL=result; stack [cret][Y.hl][Y.de][X.hl][X.de]
    pop bc
    add sp,8
    push bc
    ret

.do_sub
    ld bc,hl                    ; BC=small
    ld hl,de                    ; HL=large (ld hl,de 8c; not ex de,hl 56c)
    or a
    ld a,l
    sub c
    ld l,a
    ld a,h
    sbc a,b
    ld h,a
    jp C,sub_rev
    ld a,h
    or l
    jp NZ,sub_ok
    pop af                      ; drop large.de
    ld de,0
    pop bc
    add sp,8
    ld hl,0
    push bc
    ret

.sub_ok
    pop de                      ; large.de
    pop bc
    add sp,8
    push bc
    jp asm_f24_normalize

.sub_rev
    ; DE=large, BC=small, HL=large-small (borrowed)
    ld hl,bc                    ; HL=small
    ld a,l
    sub e
    ld l,a
    ld a,h
    sbc a,d
    ld h,a
    pop de                      ; large.de
    ld a,e
    xor 080h
    ld e,a                      ; flip sign of result
    pop bc
    add sp,8
    push bc
    jp asm_f24_normalize

.pack_y
    pop bc
    pop hl
    pop de
    add sp,4
    push bc
    ret

.pack_x
    pop bc
    add sp,4
    pop hl
    pop de
    push bc
    ret

.ovf_de
    pop bc
    add sp,8
    push bc
    jp asm_f24_inf

    ; ---- equal-exp 255: Inf±Inf / NaN ----
    ; stack: [l.mant][l.de][cret][Y.hl][Y.de][X.hl][X.de]
.hadd_eq_hi
    ld a,h
    or l
    jp NZ,hadd_nan_eq
    pop hl                      ; large mant
    ld a,h
    or l
    jp NZ,hadd_nan_de
    ld a,c
    or a
    jp NZ,hadd_nan_de           ; Inf − Inf
    pop de                      ; large.de
    ld a,e
    and 080h
    ld e,a
    ld d,255
    ld hl,0
    jp hadd_epi

.hadd_nan_eq
    pop af                      ; l.mant
.hadd_nan_de
    pop af                      ; l.de

.hadd_nan
    ld de,0
    ld d,255
    ld hl,04000h
.hadd_epi
    pop bc
    add sp,8
    push bc
    ret
