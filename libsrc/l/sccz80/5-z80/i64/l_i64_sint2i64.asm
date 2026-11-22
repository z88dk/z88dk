
SECTION code_l_sccz80
PUBLIC  l_i64_sint2i64
PUBLIC  l_i64_slong2i64

EXTERN  __i64_acc


l_i64_sint2i64:
    ld      a,h
    rlca
    sbc     a
    ld      e,a
    ld      d,a
l_i64_slong2i64:
    ld      c,l
    ld      b,h
    ld      hl,__i64_acc
    ld      (hl),c
    inc     hl
    ld      (hl),b
    inc     hl
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      a,d
    rlca
    sbc     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
    inc     hl
    ld      (hl),a
    inc     hl
    ld      (hl),a
    ret
