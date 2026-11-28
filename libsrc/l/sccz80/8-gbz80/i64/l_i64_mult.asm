; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; sccz80 crt0 library - gbz80 version
; 64-bit signed multiply: __i64_acc = stacked operand * __i64_acc (low 64 bits)
;
; The low 64 bits do not depend on the signs, so a value that does not fit
; in a signed 32-bit word uses the unsigned routine. A value that fits in a
; signed 16-bit word is one 16-bit multiply, then the same correction at
; bit 16, plus one at bit 32 when both were negative. Otherwise alo and blo
; are the low 32-bit words as unsigned and the product is
; (alo * blo) - (acc < 0 ? blo << 32 : 0) - (operand < 0 ? alo << 32 : 0).
; l_long_mult returns only 32 bits, so the wide path builds the product
; from four 16-bit multiplies. 0x7fffffff * 0x7fffffff is 0x3fffffff00000001.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_mult

EXTERN  l_i64_mult_u
EXTERN  __i64_acc
EXTERN  l_mult_ulong_0

l_i64_mult:
    ld      a,(__i64_acc+1)
    rlca
    sbc     a,a
    ld      hl,__i64_acc+2
    ld      b,6
    call    l_i64_mult_eq
    jp      nz,l_i64_mult_32
    ld      hl,sp+3                 ;operand byte 1, its own sign
    ld      a,(hl+)
    rlca
    sbc     a,a
    ld      b,6
    call    l_i64_mult_eq
    jp      nz,l_i64_mult_32
    ld      a,(__i64_acc+0)
    ld      l,a
    ld      a,(__i64_acc+1)
    ld      h,a
    push    hl                      ;alo
    ld      a,(__i64_acc+1)
    rlca
    ld      a,0
    rla
    ld      b,a                     ;sa
    ld      hl,sp+5
    ld      a,(hl)
    rlca
    ld      a,0
    rla
    ld      c,a                     ;sb
    push    bc
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                  ;de = alo
    ld      hl,sp+6
    ld      c,(hl)
    inc     hl
    ld      b,(hl)                  ;bc = blo
    call    l_mult_ulong_0
    ld      a,l
    ld      (__i64_acc+0),a
    ld      a,h
    ld      (__i64_acc+1),a
    ld      a,e
    ld      (__i64_acc+2),a
    ld      a,d
    ld      (__i64_acc+3),a
    xor     a
    ld      (__i64_acc+4),a
    ld      (__i64_acc+5),a
    ld      (__i64_acc+6),a
    ld      (__i64_acc+7),a
    pop     bc                      ;c = sb, b = sa
    ld      a,b
    or      a
    jp      z,l_i64_mult_16b
    ld      hl,sp+4
    call    l_i64_mult_sub16
l_i64_mult_16b:
    ld      a,c
    or      a
    jp      z,l_i64_mult_16c
    ld      hl,sp+0
    call    l_i64_mult_sub16
l_i64_mult_16c:
    ld      a,b
    and     c
    jp      z,l_i64_mult_16d
    call    l_i64_mult_inc4
l_i64_mult_16d:
    pop     hl
    jp      l_i64_mult_drop

l_i64_mult_32:
    ld      a,(__i64_acc+3)
    rlca
    sbc     a,a
    ld      hl,__i64_acc+4
    ld      b,4
    call    l_i64_mult_eq
    jp      nz,l_i64_mult_u
    ld      hl,sp+5
    ld      a,(hl+)
    rlca
    sbc     a,a
    ld      b,4
    call    l_i64_mult_eq
    jp      nz,l_i64_mult_u
    ld      a,(__i64_acc+2)
    ld      l,a
    ld      a,(__i64_acc+3)
    ld      h,a
    push    hl                      ;high word under the low word
    ld      a,(__i64_acc+0)
    ld      l,a
    ld      a,(__i64_acc+1)
    ld      h,a
    push    hl
    xor     a
    ld      (__i64_acc+0),a
    ld      (__i64_acc+1),a
    ld      (__i64_acc+2),a
    ld      (__i64_acc+3),a
    ld      (__i64_acc+4),a
    ld      (__i64_acc+5),a
    ld      (__i64_acc+6),a
    ld      (__i64_acc+7),a
    ld      hl,sp+0                 ;low(acc) * low(operand)
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      hl,sp+6
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    xor     a
    call    l_i64_mult_add
    ld      hl,sp+0                 ;low(acc) * high(operand)
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      hl,sp+8
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    ld      a,2
    call    l_i64_mult_add
    ld      hl,sp+2                 ;high(acc) * low(operand)
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      hl,sp+6
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    ld      a,2
    call    l_i64_mult_add
    ld      hl,sp+2                 ;high(acc) * high(operand)
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      hl,sp+8
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    ld      a,4
    call    l_i64_mult_add
    ld      hl,sp+3
    ld      a,(hl)
    rlca
    jp      nc,l_i64_mult_apos
    ld      hl,sp+6
    call    l_i64_mult_subh         ;acc was negative: subtract the operand
l_i64_mult_apos:
    ld      hl,sp+9
    ld      a,(hl)
    rlca
    jp      nc,l_i64_mult_done
    ld      hl,sp+0
    call    l_i64_mult_subh         ;operand was negative: subtract the acc
l_i64_mult_done:
    pop     hl
    pop     hl
l_i64_mult_drop:
    pop     hl
    add     sp,8
    jp      (hl)

; Add DE * BC into __i64_acc at byte offset A (0, 2, or 4). A zero limb adds nothing.
l_i64_mult_add:
    push    af
    ld      a,d
    or      e
    jp      z,l_i64_mult_add_0
    ld      a,b
    or      c
    jp      z,l_i64_mult_add_0
    call    l_mult_ulong_0
    pop     af
    push    de
    push    hl
    ld      c,a
    ld      a,4
    sub     c
    ld      b,a                     ;bytes after the 32-bit partial
    ld      a,c
    ld      hl,__i64_acc
    add     a,l
    ld      l,a
    ld      a,h
    adc     a,0
    ld      h,a
    pop     de
    ld      a,(hl)
    add     a,e
    ld      (hl+),a
    ld      a,(hl)
    adc     a,d
    ld      (hl+),a
    pop     de
    ld      a,(hl)
    adc     a,e
    ld      (hl+),a
    ld      a,(hl)
    adc     a,d
    ld      (hl+),a
    jp      nc,l_i64_mult_add_ret
l_i64_mult_add_ripple:
    inc     b
    dec     b
    jp      z,l_i64_mult_add_ret
    dec     b
    ld      a,(hl)
    adc     a,0
    ld      (hl+),a
    jr      c,l_i64_mult_add_ripple
    ret

l_i64_mult_add_0:
    pop     af
l_i64_mult_add_ret:
    ret

; Subtract the 16-bit value at HL from __i64_acc+2. Borrow stops at bit 63.
l_i64_mult_sub16:
    ld      a,(__i64_acc+2)
    sub     (hl)
    ld      (__i64_acc+2),a
    inc     hl
    ld      a,(__i64_acc+3)
    sbc     a,(hl)
    ld      (__i64_acc+3),a
    jp      nc,l_i64_mult_sub16_r
    ld      hl,__i64_acc+4
    ld      a,(hl)
    sbc     a,0
    ld      (hl+),a
    ld      a,(hl)
    sbc     a,0
    ld      (hl+),a
    ld      a,(hl)
    sbc     a,0
    ld      (hl+),a
    ld      a,(hl)
    sbc     a,0
    ld      (hl),a
l_i64_mult_sub16_r:
    ret

; Add 1 at bit 32.
l_i64_mult_inc4:
    ld      hl,__i64_acc+4
    ld      a,(hl)
    add     a,1
    ld      (hl+),a
    ld      a,(hl)
    adc     a,0
    ld      (hl+),a
    ld      a,(hl)
    adc     a,0
    ld      (hl+),a
    ld      a,(hl)
    adc     a,0
    ld      (hl),a
    ret

; Subtract the 32-bit value at HL from __i64_acc+4. Borrow stops at bit 63.
l_i64_mult_subh:
    ld      a,(__i64_acc+4)
    sub     (hl)
    ld      (__i64_acc+4),a
    inc     hl
    ld      a,(__i64_acc+5)
    sbc     a,(hl)
    ld      (__i64_acc+5),a
    inc     hl
    ld      a,(__i64_acc+6)
    sbc     a,(hl)
    ld      (__i64_acc+6),a
    inc     hl
    ld      a,(__i64_acc+7)
    sbc     a,(hl)
    ld      (__i64_acc+7),a
    ret

; A is the sign byte. The next B bytes at HL must match it.
l_i64_mult_eq:
    cp      (hl+)
    ret     nz
    dec     b
    jr      nz,l_i64_mult_eq
    ret
