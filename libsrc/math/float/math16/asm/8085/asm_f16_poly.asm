;
;  feilipu, 2020 June / 2026 July (8085)
;-------------------------------------------------------------------------
;  asm_f16_poly — Horner: res=d[n]; while(n) res=res*x+d[--n];
;-------------------------------------------------------------------------
; asm_f16_poly: HL=n, DE=d[], stack=[uret][x_half]
; asm_f16_poly_callee: stack=[uret][x][d][n]
; Prefer ld hl,(de) / ld (de),hl over byte traffic via A.
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f24_f32
EXTERN asm_f16_f24
EXTERN asm_f24_mul_f24
EXTERN asm_f24_add_f24

PUBLIC asm_f16_poly_callee
PUBLIC asm_f16_poly

.asm_f16_poly_callee
    pop bc                      ; uret
    pop hl                      ; x
    pop de                      ; d[]
    ex (sp),hl                  ; HL=n, (sp)=x
    push bc                     ; [uret][x]

.asm_f16_poly
    ; HL=n, DE=d[], [uret][x]
    ld c,l                      ; n in C (stack low byte)
    ld b,0
    push bc                     ; [n][uret][x]
    ld l,c
    ld h,0
    add hl,hl
    add hl,hl
    add hl,de                   ; &d[n]
    push hl                     ; [coeff][n][uret][x]

    ld de,sp+6
    ld hl,(de)                  ; x half
    call asm_f24_f16
    push de
    push hl                     ; [x.hl][x.de][coeff][n][uret][xhalf]

    ; res = d[n]
    ld de,sp+4
    ld hl,(de)                  ; coeff
    call load_f32
    call asm_f24_f32            ; DEHL = res

.poly_loop
    ; DEHL = res — preserve while reading n (u8 at low of word)
    push de
    push hl
    ld de,sp+10                 ; n at +6 +4
    ld a,(de)
    or a
    jp Z,poly_done
    dec a
    ld (de),a
    pop hl
    pop de                      ; DEHL = res

    ; res * x : X=res, Y=x
    push de
    push hl                     ; X=res
    ld de,sp+4
    ld hl,(de)                  ; x.hl
    push hl
    ld de,sp+8
    ld hl,(de)                  ; x.de as L=sign H=exp
    ex de,hl
    pop hl                      ; DEHL=x
    call asm_f24_mul_f24

    ; + d[n] (n already decremented; step coeff back first)
    push de
    push hl                     ; X=product
    ld de,sp+8
    ld hl,(de)                  ; coeff
    ld bc,-4
    add hl,bc
    ld (de),hl                  ; store new coeff (word)
    call load_f32
    call asm_f24_f32
    call asm_f24_add_f24
    jp poly_loop

.poly_done
    pop hl                      ; res.hl
    pop de                      ; res.de
    ; [x.hl][x.de][coeff][n][uret][xhalf]
    pop bc
    pop bc
    pop bc
    pop bc
    pop bc                      ; uret
    pop af                      ; x half
    push bc
    jp asm_f16_f24

; HL=ptr → IEEE float LE into DEHL for asm_f24_f32
; DE = b3:b2, HL = b1:b0
.load_f32
    ex de,hl                    ; DE = ptr
    ld hl,(de)                  ; HL = b1:b0
    push hl
    inc de
    inc de
    ld hl,(de)                  ; HL = b3:b2
    pop de                      ; DE = b1:b0
    ex de,hl                    ; DE = b3:b2, HL = b1:b0
    ret
