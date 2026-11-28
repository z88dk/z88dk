; sccz80 crt0 library - 8085 version
; 64-bit left shift of the stacked operand, result in __i64_acc
;
; enter : a = shift count (l_i64_aslo) or count in (__i64_acc) (l_i64_asl)
;         stack = return address, operand (8 bytes)
; exit  : __i64_acc = result, operand removed from the stack
;         a count of 64 or more clears the result

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_asl
PUBLIC  l_i64_aslo

EXTERN  __i64_acc

l_i64_asl:
    ld      a,(__i64_acc+0)

l_i64_aslo:
    cp      64
    jp      nc,l_i64_asl_sat

    ld      de,sp+2
    ld      hl,(de)
    ld      (__i64_acc+0),hl
    inc     de
    inc     de
    ld      hl,(de)
    ld      (__i64_acc+2),hl
    inc     de
    inc     de
    ld      hl,(de)
    ld      (__i64_acc+4),hl
    inc     de
    inc     de
    ld      hl,(de)
    ld      (__i64_acc+6),hl
    ld      c,a
    and     7
    ld      b,a
    ld      a,c
    rrca
    rrca
    rrca
    and     31
    ld      c,a
    ld      a,b
    or      a
    jp      z,l_i64_asl_bytes

l_i64_asl_loop:
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
    dec     b
    jp      nz,l_i64_asl_loop

l_i64_asl_bytes:
    ld      a,c
    or      a
    jp      z,l_i64_asl_done

    ld      hl,__i64_acc+7
    ld      a,l
    sub     c
    ld      e,a
    ld      a,h
    sbc     a,0
    ld      d,a
    ld      a,8
    sub     c
    ld      b,a

l_i64_asl_bmove:
    ld      a,(de-)
    ld      (hl-),a
    dec     b
    jp      nz,l_i64_asl_bmove

    xor     a

l_i64_asl_bzero:
    ld      (hl-),a
    dec     c
    jp      nz,l_i64_asl_bzero

l_i64_asl_done:
    pop     hl
    ld      de,sp+8
    ex      de,hl
    ld      sp,hl
    ex      de,hl
    jp      (hl)

l_i64_asl_sat:
    ld      hl,0
    ld      (__i64_acc+0),hl
    ld      (__i64_acc+2),hl
    ld      (__i64_acc+4),hl
    ld      (__i64_acc+6),hl
    jp      l_i64_asl_done
