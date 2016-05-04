
SECTION code_clib
SECTION code_error

PUBLIC error_llznc

EXTERN error_lznc, error_znc

   pop hl

error_llznc:

   ; set dehl'dehl = 0
   ; reset carry flag

   call again
   exx

again:
   
   call error_znc
   
   ld e,l
   ld d,h
   
   ret

