
; uint32_t _random_uniform_xor_32__fastcall(uint32_t *seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC __random_uniform_xor_32__fastcall

EXTERN asm_random_uniform_xor_32, l_long_load_mhl, l_long_store_mhl

__random_uniform_xor_32__fastcall:

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
