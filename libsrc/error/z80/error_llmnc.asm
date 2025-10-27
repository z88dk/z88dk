
SECTION code_clib
SECTION code_error

PUBLIC error_llmnc

EXTERN error_lmnc

   pop hl

error_llmnc:

   ; set dehl'dehl = -1
   ; reset carry flag

   exx
   call error_lmnc
   exx
   jp error_lmnc
