
; uint16_t _random_uniform_cmwc_8_(void *seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC __random_uniform_cmwc_8_

EXTERN __random_uniform_cmwc_8__fastcall

__random_uniform_cmwc_8_:

   pop af
   pop hl

   push hl
   push af

   jp __random_uniform_cmwc_8__fastcall
