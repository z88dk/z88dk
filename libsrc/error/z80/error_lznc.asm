
SECTION code_clib
SECTION code_error

PUBLIC error_lznc

EXTERN error_znc

   pop hl

error_lznc:

   ; set dehl = 0
   ; reset carry flag
   
   ld de,0
   jp error_znc
