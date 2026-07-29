;
;  feilipu, 2020 June / 2026 July (8085)
;-------------------------------------------------------------------------
;  asm_f16_sqrt / invsqrt — Newton (Z80 algorithm, no exx)
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_zero
EXTERN asm_f24_inf
EXTERN asm_f24_nan
EXTERN asm_f24_mul_callee
EXTERN asm_f24_add_callee

PUBLIC asm_f16_sqrt
PUBLIC asm_f16_invsqrt
PUBLIC asm_f24_sqrt
PUBLIC asm_f24_invsqrt

.asm_f16_sqrt
    call asm_f24_f16
    call asm_f24_sqrt
    jp asm_f16_f24

.asm_f16_invsqrt
    call asm_f24_f16
    call asm_f24_invsqrt
    jp asm_f16_f24

.asm_f24_sqrt
    inc d
    dec d
    jp Z,asm_f24_zero
    pop bc
    push de
    push hl
    push bc
    call asm_f24_invsqrt
    jp asm_f24_mul_callee

.asm_f24_invsqrt
    inc d
    dec d
    jp Z,asm_f24_inf
    ld a,e
    and 080h
    jp NZ,asm_f24_nan

    ld a,e
    or 080h
    ld e,a

    push de
    push hl                     ; -y for iter 2
    push de
    push hl                     ; -y for iter 1

    ld bc,hl
    ld a,b
    add a,a
    ld b,a
    or a
    ld a,d
    rra
    ld d,a
    ld a,b
    rra
    ld b,a
    xor a
    ld e,a
    ld hl,06EB5h
    ld a,l
    sub c
    ld l,a
    ld a,h
    sbc a,b
    ld h,a
    ld a,0BEh
    sbc a,d
    ld d,a
    scf
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a

    call isqz_iter
    call isqz_iter
    ret

;--------------------------------------------------------------------
; w := w*(3+w*w*(-y))/2
; In: DEHL=w, stack after CALL: [sret][-y.hl][-y.de]
;
; Build (bottom→top / first-pushed→last):
;   w_final, 3.0, -y, w
; so after all pushes top is w (for mul X), DEHL=w (Y):
;   mul → w*w
;   mul → w*w*-y  
;   add → 3+...
;   dec d
;   mul → *w_final
;--------------------------------------------------------------------
.isqz_iter
    ; save w in BC/IX-free: push as final and as ww operand later
    push de
    push hl                     ; w_final: [w_f][sret][-y]

    ld bc,08000h
    push bc
    ld bc,0C000h
    push bc                     ; 3.0: [3][w_f][sret][-y]

    ; -y: [3][w_f][sret][-y.hl@+10][-y.de@+12]
    ; push as [ -y.hl ][ -y.de ] (mant then exp/sign) for mul X
    ld de,sp+12
    ld hl,(de)                  ; -y.de
    push hl
    ld de,sp+12                 ; -y.hl now +10+2
    ld hl,(de)
    push hl                     ; [ -y.hl ][ -y.de ][3][w_f][sret][-y]

    ; push w (= w_final) for w*w: w_f @+8 after -y pushes
    ld de,sp+10
    ld hl,(de)                  ; w_f.de
    push hl
    ld de,sp+10                 ; w_f.hl @+8+2
    ld hl,(de)
    push hl                     ; [w.hl][w.de][-y][3][w_f][sret][-y]

    ; DEHL = w for mul Y
    pop hl
    pop de
    push de
    push hl                     ; restore X=w on stack, DEHL=w
    call asm_f24_mul_callee     ; w*w
    call asm_f24_mul_callee     ; * -y
    call asm_f24_add_callee     ; + 3
    dec d
    call asm_f24_mul_callee     ; * w_f

    ; expect [sret][-y]
    pop bc                      ; sret
    pop af
    pop af                      ; -y
    push bc
    ret
