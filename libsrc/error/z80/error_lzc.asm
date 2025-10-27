
SECTION code_clib
SECTION code_error

PUBLIC error_lzc

EXTERN error_zc

   pop hl

error_lzc:

   ; set dehl = 0
   ; set carry flag
   
   ld de,0
   jp error_zc
