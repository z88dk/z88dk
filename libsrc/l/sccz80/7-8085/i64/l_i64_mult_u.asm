; sccz80 crt0 library - 8085 version
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
EXTERN  l_i64_sig_8080
EXTERN  l_long_mult

l_i64_mult_u:
    ld      hl,2
    add     hl,sp
    ld      de,__i64_extra
    call    l_i64_cp8
    ld      hl,__i64_extra+7
    call    l_i64_sig_8080
    ld      c,b
    ld      hl,__i64_acc+7
    call    l_i64_sig_8080
    ld      a,b
    add     a,c
    cp      5
    jp      c,l_i64_mult_u_32

    ld      a,b
    cp      c
    jp      nc,l_i64_mult_u_keep

    ld      c,b
    ld      hl,__i64_extra
    ld      de,__i64_acc
    ld      b,8

l_i64_mult_u_swap:
    ld      a,(de)
    push    af
    ld      a,(hl)
    ld      (de+),a
    pop     af
    ld      (hl+),a
    dec     b
    jp      nz,l_i64_mult_u_swap

l_i64_mult_u_keep:
    ld      a,c
    or      a
    jp      nz,l_i64_mult_u_go

    ld      hl,__i64_acc
    ld      b,8

l_i64_mult_u_zero:
    ld      (hl+),a
    dec     b
    jp      nz,l_i64_mult_u_zero

    jp      l_i64_mult_u_done

l_i64_mult_u_go:
    add     a,a
    add     a,a
    add     a,a
    ld      b,a
    push    bc
    ld      hl,0
    push    hl
    push    hl
    push    hl
    push    hl

l_i64_mult_u_loop:
    ld      a,(__i64_extra)
    rra
    jp      nc,l_i64_mult_u_skip

    ld      hl,0
    add     hl,sp
    ex      de,hl
    ld      hl,__i64_acc
    ld      c,8
    and     a

l_i64_mult_u_add:
    ld      a,(de)
    adc     a,(hl+)
    ld      (de+),a
    dec     c
    jp      nz,l_i64_mult_u_add

l_i64_mult_u_skip:
    ld      hl,8
    add     hl,sp
    ld      c,(hl)
    ld      a,c
    cp      7
    jp      c,l_i64_mult_u_shrslow

    call    l_i64_shr1_extra
    jp      l_i64_mult_u_shrdone

l_i64_mult_u_shrslow:
    ld      d,0
    ld      e,c
    ld      hl,__i64_extra-1
    add     hl,de
    and     a

l_i64_mult_u_shr:
    ld      a,(hl)
    rra
    ld      (hl-),a
    dec     c
    jp      nz,l_i64_mult_u_shr

l_i64_mult_u_shrdone:
    call    l_i64_shl1_acc
    dec     b
    jp      nz,l_i64_mult_u_loop

    ld      hl,0
    add     hl,sp
    ld      de,__i64_acc
    call    l_i64_cp8
    ld      hl,10
    add     hl,sp
    ld      sp,hl

l_i64_mult_u_done:
    pop     de
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    ex      de,hl
    jp      (hl)

l_i64_mult_u_32:
    ld      hl,(__i64_extra+2)
    push    hl
    ld      hl,(__i64_extra)
    push    hl
    ld      hl,(__i64_acc+2)
    ex      de,hl
    ld      hl,(__i64_acc)
    call    l_long_mult
    ld      (__i64_acc),hl
    ex      de,hl
    ld      (__i64_acc+2),hl
    ld      hl,0
    ld      (__i64_acc+4),hl
    ld      (__i64_acc+6),hl
    jp      l_i64_mult_u_done

; One-bit left shift of __i64_acc. Carry in is 0. BC is preserved.

l_i64_shl1_acc:
    and     a
    ld      hl,(__i64_acc+2)
    ex      de,hl
    ld      hl,(__i64_acc+0)
    add     hl,hl
    rl      de
    ld      (__i64_acc+0),hl
    ex      de,hl
    ld      (__i64_acc+2),hl
    ld      hl,(__i64_acc+6)
    ex      de,hl
    ld      hl,(__i64_acc+4)
    ld      a,l
    adc     a,l
    ld      l,a
    ld      a,h
    adc     a,h
    ld      h,a
    rl      de
    ld      (__i64_acc+4),hl
    ex      de,hl
    ld      (__i64_acc+6),hl
    ret

; Logical right shift of __i64_extra by one byte-group of eight.
; Carry in is 0. BC is preserved. The shifted-out bits are discarded.
; Used when the significant count is 7 or 8: the bytes above that
; count are already zero, and this helper is then shorter than the
; per-byte loop.

l_i64_shr1_extra:
    ld      hl,(__i64_extra+6)
    ld      a,h
    and     a
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    ex      de,hl
    ld      hl,(__i64_extra+4)
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    ld      (__i64_extra+4),hl
    ex      de,hl
    ld      (__i64_extra+6),hl
    ld      hl,(__i64_extra+2)
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    ld      (__i64_extra+2),hl
    ld      hl,(__i64_extra+0)
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    ld      (__i64_extra+0),hl
    ret
