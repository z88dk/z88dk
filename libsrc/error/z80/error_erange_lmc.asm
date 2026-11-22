
SECTION code_clib
SECTION code_error

PUBLIC error_erange_lmc

EXTERN error_erange_mc

   pop hl

error_erange_lmc:

   ; set dehl = -1
   ; set errno = ERANGE
   ; set carry flag
   
   call error_erange_mc
   
   ld e,l
   ld d,h
   
   ret
