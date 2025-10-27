
; uint32_t _random_uniform_xor_32_(uint32_t *seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC __random_uniform_xor_32_

EXTERN __random_uniform_xor_32__fastcall

__random_uniform_xor_32_:

   pop af
   pop hl
   
   push hl
   push af

   jp __random_uniform_xor_32__fastcall
