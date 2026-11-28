; sccz80 crt0 library - 8080 version
; 64-bit multiply: __i64_acc = stacked operand * __i64_acc (low 64 bits)
; A product that must fit in 32 bits goes to l_long_mult. Otherwise shift
; and add over the bytes of the operand with fewer significant bytes.
;
; enter : stack = return address, operand (8 bytes)
; exit  : __i64_acc = product, operand removed from the stack

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_mult_u

EXTERN  __i64_acc
EXTERN  __i64_extra
EXTERN  l_i64_cp8
EXTERN  l_i64_load
EXTERN  l_i64_sig_8080
EXTERN  l_long_mult

l_i64_mult_u:
    ld      hl,2
    add     hl,sp
    ld      de,__i64_extra
    call    l_i64_cp8               ;extra = operand
    ld      hl,__i64_extra+7
    call    l_i64_sig_8080
    ld      c,b                     ;c = bytes in extra
    ld      hl,__i64_acc+7
    call    l_i64_sig_8080          ;b = bytes in acc
    ld      a,b
    add     a,c
    cp      5
    jp      c,l_i64_mult_u_32       ;at most four bytes of product
    ld      a,b
    cp      c
    jp      nc,l_i64_mult_u_keep
    ld      c,b                     ;acc is the smaller one: swap
    ld      hl,__i64_extra
    ld      de,__i64_acc
    ld      b,8
l_i64_mult_u_swap:
    ld      a,(de)
    push    af
    ld      a,(hl)
    ld      (de),a
    pop     af
    ld      (hl),a
    inc     hl
    inc     de
    dec     b
    jp      nz,l_i64_mult_u_swap
l_i64_mult_u_keep:
    ld      a,c
    or      a
    jp      nz,l_i64_mult_u_go
    ld      hl,__i64_acc            ;multiplier is zero
    ld      b,8
l_i64_mult_u_zero:
    ld      (hl),a
    inc     hl
    dec     b
    jp      nz,l_i64_mult_u_zero
    jp      l_i64_mult_u_done
l_i64_mult_u_go:
    add     a,a
    add     a,a
    add     a,a
    ld      b,a                     ;b = bits to run
    push    bc                      ;byte count at sp+8
    ld      hl,0
    push    hl
    push    hl
    push    hl
    push    hl                      ;product = 0, at sp
l_i64_mult_u_loop:
    ld      a,(__i64_extra)
    rra
    jp      nc,l_i64_mult_u_skip
    ld      hl,0
    add     hl,sp
    ld      de,hl
    ld      hl,__i64_acc
    ld      c,8
    and     a
l_i64_mult_u_add:
    ld      a,(de)
    adc     a,(hl)
    ld      (de),a
    inc     de
    inc     hl
    dec     c
    jp      nz,l_i64_mult_u_add
l_i64_mult_u_skip:
    ld      hl,8
    add     hl,sp
    ld      c,(hl)                  ;c = bytes in the multiplier
    ld      d,0
    ld      e,c
    ld      hl,__i64_extra-1
    add     hl,de                   ;hl = top byte
    and     a
l_i64_mult_u_shr:
    ld      a,(hl)
    rra
    ld      (hl-),a
    dec     c
    jp      nz,l_i64_mult_u_shr
    ld      hl,__i64_acc
    ld      c,8
    and     a
l_i64_mult_u_shl:
    ld      a,(hl)
    rla
    ld      (hl+),a
    dec     c
    jp      nz,l_i64_mult_u_shl
    dec     b
    jp      nz,l_i64_mult_u_loop
    ld      hl,0
    add     hl,sp
    call    l_i64_load
    ld      hl,10
    add     hl,sp
    ld      sp,hl
l_i64_mult_u_done:
    IF __CPU_GBZ80__
    pop     hl
    add     sp,8
    ELSE
    pop     de
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    ld      hl,de
    ENDIF
    jp      (hl)

l_i64_mult_u_32:
    ld      hl,(__i64_extra+2)
    push    hl
    ld      hl,(__i64_extra)
    push    hl
    ld      hl,(__i64_acc+2)
    ld      de,hl
    ld      hl,(__i64_acc)
    call    l_long_mult
    ld      (__i64_acc),hl
    ld      hl,de
    ld      (__i64_acc+2),hl
    ld      hl,0
    ld      (__i64_acc+4),hl
    ld      (__i64_acc+6),hl
    jp      l_i64_mult_u_done
