; sccz80 crt0 library - 8080 version
; Unsigned 64-bit divide core for the 8080-class CPUs (no exx, no ix),
; behind l_i64_div, l_i64_div_u, l_i64_mod and l_i64_mod_u.
; Restoring, one bit per pass
;
; enter : __i64_extra = dividend, __i64_acc = divisor
; exit  : __i64_extra = quotient, __i64_acc = remainder
; uses  : af, bc, de, hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_udivmod_8080

EXTERN  __i64_acc
EXTERN  __i64_extra
EXTERN  l_i64_cp8
EXTERN  l_add_64_mde_mhl
EXTERN  l_sub_64_mde_mhl

l_i64_udivmod_8080:
    ld      hl,0
    push    hl
    push    hl
    push    hl
    push    hl                      ;remainder = 0, at sp
    ld      b,64
l_i64_udivmod_loop:
    ld      hl,__i64_extra          ;quotient <<= 1
    ld      c,8
    and     a
l_i64_udivmod_q:
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    dec     c
    jp      nz,l_i64_udivmod_q
    sbc     a,a                     ;keep the bit shifted out
    ld      hl,0
    add     hl,sp
    ld      c,8
    add     a,a                     ;carry = that bit
l_i64_udivmod_r:
    ld      a,(hl)                  ;remainder = remainder << 1 | carry
    rla
    ld      (hl),a
    inc     hl
    dec     c
    jp      nz,l_i64_udivmod_r
    jp      c,l_i64_udivmod_sub     ;bit 64 set: always >= divisor
    ld      hl,0
    add     hl,sp
    ex      de,hl
    ld      hl,__i64_acc
    call    l_sub_64_mde_mhl
    jp      nc,l_i64_udivmod_bit
    ld      hl,0
    add     hl,sp
    ex      de,hl
    ld      hl,__i64_acc
    call    l_add_64_mde_mhl        ;too far, put it back
    jp      l_i64_udivmod_next
l_i64_udivmod_sub:
    ld      hl,0
    add     hl,sp
    ex      de,hl
    ld      hl,__i64_acc
    call    l_sub_64_mde_mhl
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
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    ret
