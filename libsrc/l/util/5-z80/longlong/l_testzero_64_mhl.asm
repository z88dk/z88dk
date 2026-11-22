
SECTION code_clib
SECTION code_l

PUBLIC l_testzero_64_mhl

l_testzero_64_mhl:

   ; test if 64-bit number at address hl is zero
   ;
   ; enter : hl = longlong *
   ;
   ; exit  : hl = longlong* + 8 bytes
   ;         z flag set if longlong == 0
   ;
   ; uses  : af, hl
   
   xor a
   call again

again:

   or (hl)
   inc hl
   
   or (hl)
   inc hl
   
   or (hl)
   inc hl
   
   or (hl)
   inc hl
   
   ret
 