
SECTION code_l_sccz80
PUBLIC  l_i64_uint2i64
PUBLIC  l_i64_ulong2i64

EXTERN  __i64_acc


l_i64_uint2i64:
    ld      de,0
l_i64_ulong2i64:
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
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
    inc     hl
    ld      (hl),a
    inc     hl
    ld      (hl),a
    ret
