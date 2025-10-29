
SECTION code_clib
SECTION code_error

PUBLIC error_llznc

EXTERN error_lznc

   pop hl

error_llznc:

   ; set dehl'dehl = 0
   ; reset carry flag

   exx
   call error_lznc
   exx
   jp error_lznc

