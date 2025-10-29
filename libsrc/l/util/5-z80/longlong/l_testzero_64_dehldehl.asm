
SECTION code_clib
SECTION code_l

PUBLIC l_testzero_64_dehldehl

l_testzero_64_dehldehl:

   ; test if 64-bit number is zero
   ;
   ; enter : dehl'dehl = 64-bit number
   ;
   ; exit  : z flag set if longlong == 0
   ;
   ; uses  : af

   exx
   
   ld a,d
   or e
   or h
   or l
   
   exx
   
   or d
   or e
   or h
   or l
   
   ret
