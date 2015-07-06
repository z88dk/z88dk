
; uint16_t _random_uniform_xor_8__fastcall(uint32_t seed)

SECTION code_stdlib

PUBLIC __random_uniform_xor_8__fastcall

EXTERN asm_random_uniform_xor_8

__random_uniform_xor_8__fastcall:

   call asm_random_uniform_xor_8
   
   ld l,a
   ld h,0
   
   ret
