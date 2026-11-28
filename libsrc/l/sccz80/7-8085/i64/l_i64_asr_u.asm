; sccz80 crt0 library - 8085 version
; 64-bit logical right shift of the stacked operand, result in __i64_acc
;
; enter : a = shift count (l_i64_asr_uo) or count in (__i64_acc) (l_i64_asr_u)
;         stack = return address, operand (8 bytes)
; exit  : __i64_acc = result, operand removed from the stack
;         a count of 64 or more clears the result

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_asr_u
PUBLIC  l_i64_asr_uo

EXTERN  __i64_acc

l_i64_asr_u:
    ld      a,(__i64_acc+0)

l_i64_asr_uo:
    cp      64
    jp      nc,l_i64_asr_u_sat

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
    jp      z,l_i64_asr_u_bytes

l_i64_asr_u_loop:
    ld      hl,(__i64_acc+6)
    ld      a,h
    and     a
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    ld      (__i64_acc+6),hl
    ld      hl,(__i64_acc+4)
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    ld      (__i64_acc+4),hl
    ld      hl,(__i64_acc+2)
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    ld      (__i64_acc+2),hl
    ld      hl,(__i64_acc+0)
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    ld      (__i64_acc+0),hl
    dec     b
    jp      nz,l_i64_asr_u_loop

l_i64_asr_u_bytes:
    ld      a,c
    or      a
    jp      z,l_i64_asr_u_done

    ld      hl,__i64_acc
    ld      de,hl
    ld      a,e
    add     a,c
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      a,8
    sub     c
    ld      b,a

l_i64_asr_u_bmove:
    ld      a,(de+)
    ld      (hl+),a
    dec     b
    jp      nz,l_i64_asr_u_bmove

    xor     a

l_i64_asr_u_bzero:
    ld      (hl+),a
    dec     c
    jp      nz,l_i64_asr_u_bzero

l_i64_asr_u_done:
    pop     hl
    ld      de,sp+8
    ex      de,hl
    ld      sp,hl
    ex      de,hl
    jp      (hl)

l_i64_asr_u_sat:
    ld      hl,0
    ld      (__i64_acc+0),hl
    ld      (__i64_acc+2),hl
    ld      (__i64_acc+4),hl
    ld      (__i64_acc+6),hl
    jp      l_i64_asr_u_done
