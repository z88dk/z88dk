
SECTION code_clib
SECTION code_error

PUBLIC error_llzc

EXTERN error_lzc

   pop hl

error_llzc:

   ; set dehl'dehl = 0
   ; set carry flag

   exx
   call error_lzc
   exx
   jp error_lzc
