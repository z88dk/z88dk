
SECTION code_clib
SECTION code_l_sccz80
PUBLIC  l_mult
PUBLIC  l_mult_u

PUBLIC  l_mult_0

; Entry: bc = value1
;        de = value2
; Exit:  hl = value1 * value2
.l_mult_0
    ld hl,bc

; Entry: hl = value1
;        de = value2
; Exit:  hl = value1 * value2

.l_mult
.l_mult_u
    ld a,d                      ; a = xh
    ld d,h                      ; d = yh
    ld h,a                      ; h = xh
    ld c,e                      ; c = xl
    ld b,l                      ; b = yl
    mul de                      ; yh * yl
    ex de,hl
    mul de                      ; xh * yl
    add hl,de                   ; add cross products
    ld de,bc
    mul de                      ; yl * xl
    ld a,l                      ; cross products lsb
    add a,d                     ; add to msb final
    ld h,a
    ld l,e                      ; hl = final
    ret
