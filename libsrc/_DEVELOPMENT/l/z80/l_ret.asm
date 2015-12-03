
SECTION code_clib
SECTION code_l

PUBLIC l_ret

   ; function present in some rom crts
   ; if number of pops changes, check crts
   
   pop hl
   
l_ret:

   ; Do-nothing function used as a stub by some library functions

   ret
