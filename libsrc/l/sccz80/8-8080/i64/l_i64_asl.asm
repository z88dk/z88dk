; sccz80 crt0 library - 8080 version
; 64-bit shift of the stacked operand by a bits, result in __i64_acc
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
EXTERN  l_i64_cp8

l_i64_asl:
    ld      a,(__i64_acc+0)
l_i64_aslo:
    push    af
    cp      64
    jp      nc,l_i64_asl_sat
    ld      hl,4
    add     hl,sp
    ld      de,__i64_acc
    call    l_i64_cp8
    pop     af
    ld      c,a
    and     7
    ld      b,a
    ld      a,c
    rrca
    rrca
    rrca
    and     31
    push    af
    ld      a,b
    or      a
    jp      z,l_i64_asl_bytes
    ld      c,b
l_i64_asl_loop:
    ld      hl,__i64_acc
    ld      b,8
    and     a
l_i64_asl_1:
    ld      a,(hl)
    rla
    ld      (hl+),a
    dec     b
    jp      nz,l_i64_asl_1
    dec     c
    jp      nz,l_i64_asl_loop
l_i64_asl_bytes:
    pop     af
    or      a
    jp      z,l_i64_asl_done
    ld      c,a
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
    jp      l_i64_asl_done
l_i64_asl_sat:
    pop     af
    ld      hl,0
    ld      (__i64_acc+0),hl
    ld      (__i64_acc+2),hl
    ld      (__i64_acc+4),hl
    ld      (__i64_acc+6),hl
l_i64_asl_done:
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
