
SECTION code_clib
SECTION code_error

PUBLIC error_lmnc

EXTERN error_mnc

   pop hl

error_lmnc:

   ; set dehl = -1
   ; reset carry flag
   
   ld de,-1
   jp error_mnc
