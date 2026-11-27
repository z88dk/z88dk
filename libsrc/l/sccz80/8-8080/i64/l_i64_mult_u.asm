; sccz80 crt0 library - 8080 version
; 64-bit multiply: __i64_acc = stacked operand * __i64_acc (low 64 bits)
;
; enter : stack = return address, operand (8 bytes)
; exit  : __i64_acc = product, operand removed from the stack

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_mult_u

EXTERN  __i64_acc
EXTERN  __i64_extra
EXTERN  l_i64_cp8
EXTERN  l_add_64_mde_mhl

l_i64_mult_u:
    ld      hl,2
    add     hl,sp
    ld      de,__i64_extra
    call    l_i64_cp8               ;extra = multiplier
    ld      hl,0
    push    hl
    push    hl
    push    hl
    push    hl                      ;product = 0, at sp
    ld      b,64
l_i64_mult_u_loop:
    ld      a,(__i64_extra)
    rra
    jp      nc,l_i64_mult_u_skip
    ld      hl,0
    add     hl,sp
    ex      de,hl
    ld      hl,__i64_acc
    call    l_add_64_mde_mhl        ;product += multiplicand
l_i64_mult_u_skip:
    ld      hl,__i64_extra+7        ;multiplier >>= 1
    ld      c,8
    and     a
l_i64_mult_u_shr:
    ld      a,(hl)
    rra
    ld      (hl),a
    dec     hl
    dec     c
    jp      nz,l_i64_mult_u_shr
    ld      hl,__i64_acc            ;multiplicand <<= 1
    ld      c,8
    and     a
l_i64_mult_u_shl:
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    dec     c
    jp      nz,l_i64_mult_u_shl
    dec     b
    jp      nz,l_i64_mult_u_loop
    ld      hl,0
    add     hl,sp
    ld      de,__i64_acc
    call    l_i64_cp8
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    pop     de
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    ex      de,hl
    jp      (hl)
