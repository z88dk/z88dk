; sccz80 crt0 library - 8080 version
; Unsigned 64-bit divide core for the 8080-class CPUs (no exx, no ix),
; behind l_i64_div, l_i64_div_u, l_i64_mod and l_i64_mod_u.
; Operands that both fit in 32 bits go to l_long_div_u and l_long_mod_u.
; Otherwise restoring, one bit per pass: only the significant bytes of the
; dividend are shifted, and the remainder arithmetic is as wide as the divisor.
;
; enter : __i64_extra = dividend, __i64_acc = divisor
; exit  : l_i64_udiv_8080: __i64_extra = quotient
;         l_i64_umod_8080: __i64_acc = remainder
;         (the bit loop leaves both)
; uses  : af, bc, de, hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_udiv_8080
PUBLIC  l_i64_umod_8080

EXTERN  __i64_acc
EXTERN  __i64_extra
EXTERN  l_i64_cp8
EXTERN  l_i64_sig_8080
EXTERN  l_long_div_u
EXTERN  l_long_mod_u

l_i64_udiv_8080:
    ld      e,1
    jp      l_i64_udivmod_go8
l_i64_umod_8080:
    ld      e,2
l_i64_udivmod_go8:
    ld      hl,__i64_extra+7
    call    l_i64_sig_8080
    ld      a,b
    or      a
    jp      nz,l_i64_udivmod_go
    ld      hl,__i64_acc            ;dividend is zero: so is the remainder
    ld      b,8
l_i64_udivmod_zero:
    ld      (hl),a
    inc     hl
    dec     b
    jp      nz,l_i64_udivmod_zero
    ret
l_i64_udivmod_go:
    ld      c,b                     ;c = bytes in the dividend
    ld      hl,__i64_acc+7
    call    l_i64_sig_8080
    ld      a,c
    cp      5
    jp      nc,l_i64_udivmod_wide
    ld      a,b
    cp      5
    jp      c,l_i64_udivmod_32
l_i64_udivmod_wide:
    ld      a,b
    cp      8
    jp      z,l_i64_udivmod_w
    inc     a                       ;one more byte than the divisor
l_i64_udivmod_w:
    ld      b,a                     ;b = remainder width
    push    bc                      ;c at sp+8, b at sp+9
    ld      hl,0
    push    hl
    push    hl
    push    hl
    push    hl                      ;remainder = 0, at sp
    ld      a,c
    add     a,a
    add     a,a
    add     a,a
    ld      b,a                     ;b = bits to run
l_i64_udivmod_loop:
    ld      hl,8
    add     hl,sp
    ld      c,(hl)
    ld      hl,__i64_extra          ;dividend <<= 1, quotient bit in at the bottom
    and     a
l_i64_udivmod_q:
    ld      a,(hl)
    rla
    ld      (hl+),a
    dec     c
    jp      nz,l_i64_udivmod_q
    sbc     a,a                     ;keep the bit shifted out
    ld      hl,9
    add     hl,sp
    ld      c,(hl)
    ld      hl,0
    add     hl,sp
    add     a,a                     ;carry = that bit
l_i64_udivmod_r:
    ld      a,(hl)                  ;remainder = remainder << 1 | carry
    rla
    ld      (hl),a
    inc     hl
    dec     c
    jp      nz,l_i64_udivmod_r
    jp      c,l_i64_udivmod_sub     ;bit out of a full width: always >= divisor
    call    l_i64_udivmod_dosub
    jp      nc,l_i64_udivmod_bit
    call    l_i64_udivmod_doadd     ;too far, put it back
    jp      l_i64_udivmod_next
l_i64_udivmod_sub:
    call    l_i64_udivmod_dosub
l_i64_udivmod_bit:
    ld      hl,__i64_extra
    inc     (hl)
l_i64_udivmod_next:
    dec     b
    jp      nz,l_i64_udivmod_loop
    ld      hl,0
    add     hl,sp
    ld      de,__i64_acc
    call    l_i64_cp8
    ld      hl,10
    add     hl,sp
    ld      sp,hl
    ret

; remainder -= divisor over the remainder width; carry = borrow
l_i64_udivmod_dosub:
    ld      hl,11
    add     hl,sp
    ld      c,(hl)
    ld      hl,2
    add     hl,sp
    IF __CPU_GBZ80__
    ld      d,h
    ld      e,l
    ELSE
    ex      de,hl
    ENDIF
    ld      hl,__i64_acc
    and     a
l_i64_udivmod_s:
    ld      a,(de)
    sbc     a,(hl)
    ld      (de),a
    inc     de
    inc     hl
    dec     c
    jp      nz,l_i64_udivmod_s
    ret

; remainder += divisor over the remainder width
l_i64_udivmod_doadd:
    ld      hl,11
    add     hl,sp
    ld      c,(hl)
    ld      hl,2
    add     hl,sp
    IF __CPU_GBZ80__
    ld      d,h
    ld      e,l
    ELSE
    ex      de,hl
    ENDIF
    ld      hl,__i64_acc
    and     a
l_i64_udivmod_a:
    ld      a,(de)
    adc     a,(hl)
    ld      (de),a
    inc     de
    inc     hl
    dec     c
    jp      nz,l_i64_udivmod_a
    ret

; both operands fit in 32 bits, e = 1 for the quotient, 2 for the remainder
l_i64_udivmod_32:
    ld      a,e
    cp      1
    ld      hl,(__i64_extra+2)
    push    hl
    ld      hl,(__i64_extra)
    push    hl
    ld      hl,(__i64_acc+2)
    ex      de,hl
    ld      hl,(__i64_acc)
    jp      z,l_i64_udivmod_32q
    call    l_long_mod_u
    ld      (__i64_acc),hl
    ex      de,hl
    ld      (__i64_acc+2),hl
    ld      hl,0
    ld      (__i64_acc+4),hl
    ld      (__i64_acc+6),hl
    ret
l_i64_udivmod_32q:
    call    l_long_div_u
    ld      (__i64_extra),hl
    ex      de,hl
    ld      (__i64_extra+2),hl
    ret
