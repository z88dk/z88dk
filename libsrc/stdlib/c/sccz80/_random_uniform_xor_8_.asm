
; uint16_t _random_uniform_xor_8_(uint32_t *seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC _random_uniform_xor_8_

EXTERN asm_random_uniform_xor_8, l_long_load_mhl, l_long_store_mhl

_random_uniform_xor_8_:

   push hl
   call l_long_load_mhl        ; dehl = seed

   call asm_random_uniform_xor_8
   
   ld c,l
   ld b,h
   
   pop hl
   call l_long_store_mhl
   
   ld l,a
   ld h,0
   
   ret
