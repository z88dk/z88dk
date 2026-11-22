
; uint32_t _random_uniform_xor_32_(uint32_t *seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC _random_uniform_xor_32_

EXTERN asm_random_uniform_xor_32, l_long_load_mhl, l_long_store_mhl

_random_uniform_xor_32_:

   push hl
   call l_long_load_mhl        ; dehl = seed
   
   call asm_random_uniform_xor_32
   
   ld c,l
   ld b,h
   
   pop hl
   call l_long_store_mhl
   
   ld l,c
   ld h,b
   
   ret
