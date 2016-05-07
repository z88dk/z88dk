
SECTION code_clib
SECTION code_l

PUBLIC l_add_64_dehldehl_a

l_add_64_dehldehl_a:

   ; add 64-bit number and 8-bit number
   ;
   ; enter : dehl'dehl = 64-bit number
   ;                 a = 8-bit number
   ;
   ; exit  : dehl'dehl += a
   ;         z flag set if overflow
   ;
   ; uses  : af, de, hl, de', hl'
   
   add a,l
   ld l,a
   ret nc

   inc h
   ret nz
   
   inc e
   ret nz
   
   inc d
   ret nz
   
   exx
   
   inc l
   jr nz, exx_ret
   
   inc h
   jr nz, exx_ret
   
   inc e
   jr nz, exx_ret
   
   inc d

exx_ret:

   exx
   ret
