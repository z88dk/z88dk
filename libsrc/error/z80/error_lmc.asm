
SECTION code_clib
SECTION code_error

PUBLIC error_lmc

EXTERN error_mc

   pop hl

error_lmc:

   ; set dehl = -1
   ; set carry flag
   
   ld de,-1
   jp error_mc
