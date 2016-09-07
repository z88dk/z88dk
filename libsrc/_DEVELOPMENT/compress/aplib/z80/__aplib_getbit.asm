SECTION code_clib
SECTION code_compress_aplib

PUBLIC __aplib_getbit

EXTERN __aplib_var_bits

__aplib_getbit:

   push bc
      ld bc,(__aplib_var_bits)
      rrc c
      jr nc, l0
      ld b,(hl)
      inc hl
l0:   ld a,c
      and b
      ld (__aplib_var_bits),bc
   pop bc
   ret
