
; uint16_t _random_uniform_cmwc_8_(void *seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC _random_uniform_cmwc_8_

EXTERN asm_random_uniform_cmwc_8

_random_uniform_cmwc_8_:

   call asm_random_uniform_cmwc_8
   
   ld l,a
   ld h,0
   
   ret
