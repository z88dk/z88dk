
; uint32_t _random_uniform_xor_32_(uint32_t seed)

SECTION code_stdlib

PUBLIC __random_uniform_xor_32_

EXTERN asm_random_uniform_xor_32

__random_uniform_xor_32_:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp asm_random_uniform_xor_32
