
SECTION code_clib
SECTION code_error

PUBLIC error_einval_lmc

EXTERN error_einval_mc

   pop hl

error_einval_lmc:

   ; set dehl = -1
   ; set errno = EINVAL
   ; set carry flag
   
   call error_einval_mc
   
   ld e,l
   ld d,h
   
   ret
