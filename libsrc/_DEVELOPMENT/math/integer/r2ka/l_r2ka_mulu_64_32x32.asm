;
;  feilipu, 2023 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN l_mulu_32_16x16

PUBLIC l_r2ka_mulu_64_32x32, l0_r2ka_mulu_64_32x32

l0_r2ka_mulu_32_16x16:

    ; multiplication of two 16-bit numbers into a 32-bit product
    ;
    ; enter : hl'= 16-bit multiplier   = y
    ;         hl = 16-bit multiplicand = x
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    ex de,hl'
    jp l_mulu_32_16x16

l_r2ka_mulu_64_32x32:

    ; multiplication of two 32-bit numbers into a 64-bit product
    ;
    ; enter : de hl = 32-bit multiplicand = x
    ;         de'hl'= 32-bit multiplier   = y
    ;
    ; exit  : dehl dehl' = 64-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    xor a
    or e
    or d
    exx

    or e
    or d
    jr Z,l0_r2ka_mulu_32_16x16  ; demote if both are uint16_t

    ex de',hl
    ld bc,hl
    exx

    ld bc,hl

l0_r2ka_mulu_64_32x32:

    ; multiplication of two 32-bit numbers into a 64-bit product
    ;
    ; enter : de'de = 32-bit multiplier    = x
    ;         bc'bc = 32-bit multiplicand  = y
    ;
    ; exit  : dehl dehl' = 64-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    push de                     ; xl
    push bc                     ; yl
    ld hl,bc                    ; yl
    call l_mulu_32_16x16        ; yl * xl = de*hl => dehl ; uses bc, hl'

    ex de',hl                   ; p0 = (xl*yl)l <> xh
    ex de,hl                    ; (xl*yl)h <> xh
    ex (sp),hl                  ; yl <> (xl*yl)h
    push de                     ; xh
    call l_mulu_32_16x16        ; xh * yl = de*hl => dehl ; uses bc, hl'

    ex de,hl'                   ; ?? > (xh*yl)h
    pop de                      ; xh
    pop bc                      ; (xl*yl)h
    xor a                       ; clear p1 carry store
    add hl,bc                   ; pp1 = (xh*yl)l + (xl*yl)h
    adc a,a                     ; pp1 carry (xh*yl)l + (xl*yl)h
    ex (sp),hl                  ; xl <> pp1
    exx                         ;'

    ex de,hl                    ;'(xh*yl)h <> p0
    ex (sp),hl                  ;'p0 <> pp1
    push hl                     ;'pp1
    push af                     ;'pp1 carry

    ex de',hl                   ;'pp1 <> xh
    ld de',bc                   ;'yh
    push hl                     ;'xh
    exx

    call l_mulu_32_16x16        ; yh * xl = de*hl => dehl ; uses bc, hl'

    ex de,hl'                   ; ?? > (xl*yh)h
    pop bc                      ; xh
    pop af                      ; pp1 carry
    pop de                      ; pp1
    add hl,de                   ; p1 = pp1 + (xl*yh)l
    adc a,0                     ; p1 carry
    push hl                     ; p1
    push af                     ; p1 carry
    exx                         ;'

    ld hl',bc                   ;'yh
    exx

    ex de,hl'                   ; ?? >> (xl*yh)h
    ld bc',de                   ; (xl*yh)h
    ld de,bc                    ; xh
    call l_mulu_32_16x16        ; yh * xh = de*hl => dehl ; uses bc, hl'

    exx                         ;'

    pop af                      ;'p1 carry
    ld l,a
    xor a                       ;'p2 carry store
    ld h,a
    add hl,de                   ;'pp2 = p1 carry + (xh*yl)h
    adc a,a                     ;'pp2 carry
    add hl,bc                   ;'pp2 = pp2 + (xl*yh)h
    adc a,0                     ;'pp2 carry
    ex de,hl                    ;'pp2
    ld bc',de                   ;'pp2
    pop de                      ;'p1
    pop hl                      ;'p0
    exx

    add hl,bc                   ; p2 = pp2 + (xh*yh)l
    adc a,0                     ; p2 carry
    add a,e                     ; p3 + p2 carry
    ld e,a                      ; p3
    ret NC

    inc d
    ret                         ;exit  : DEHL DEHL' = 64-bit product
