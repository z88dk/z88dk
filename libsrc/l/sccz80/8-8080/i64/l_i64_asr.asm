; sccz80 crt0 library - 8080 version
; 64-bit shift of the stacked operand by a bits, result in __i64_acc
;
; enter : a = shift count (l_i64_asro) or count in (__i64_acc) (l_i64_asr)
;         stack = return address, operand (8 bytes)
; exit  : __i64_acc = result, operand removed from the stack
;         a count of 64 or more fills the result with the sign

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_asr
PUBLIC  l_i64_asro

EXTERN  __i64_acc
EXTERN  l_i64_load

l_i64_asr:
    ld      a,(__i64_acc+0)
l_i64_asro:
    push    af
    cp      64
    jp      nc,l_i64_asr_sat
    ld      hl,sp+4
    call    l_i64_load
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
    jp      z,l_i64_asr_bytes
    ld      c,b
l_i64_asr_loop:
    ld      hl,__i64_acc+7
    ld      b,8
    ld      a,(hl)
    rla
l_i64_asr_1:
    ld      a,(hl)
    rra
    ld      (hl-),a
    dec     b
    jp      nz,l_i64_asr_1
    dec     c
    jp      nz,l_i64_asr_loop
l_i64_asr_bytes:
    pop     af
    or      a
    jp      z,l_i64_asr_done
    ld      c,a
    ld      a,(__i64_acc+7)
    rlca
    sbc     a,a
    push    af
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
l_i64_asr_bmove:
    ld      a,(de+)
    ld      (hl+),a
    dec     b
    jp      nz,l_i64_asr_bmove
    pop     af
l_i64_asr_fill:
    ld      (hl+),a
    dec     c
    jp      nz,l_i64_asr_fill
    jp      l_i64_asr_done
l_i64_asr_sat:
    ld      hl,sp+11
    ld      a,(hl)
    rlca
    sbc     a,a
    pop     bc
    ld      l,a
    ld      h,a
    ld      (__i64_acc+0),hl
    ld      (__i64_acc+2),hl
    ld      (__i64_acc+4),hl
    ld      (__i64_acc+6),hl
l_i64_asr_done:
    pop     de
    ld      hl,sp+8
    ld      sp,hl
    ex      de,hl
    jp      (hl)
