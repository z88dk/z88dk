
SECTION code_clib
SECTION code_l

PUBLIC l_inc_64_dehldehl, l0_inc_64_dehldehl

l_inc_64_dehldehl:

   ; increment 64-bit value
   ;
   ; enter : dehl'dehl = 32 bit number
   ;
   ; exit  : dehl'dehl += 1
   ;
   ; uses  : f, de, hl, de', hl'

   inc l
   ret nz

l0_inc_64_dehldehl:

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
   
   inc e                       ; need z flag set correctly so no 'inc de'
   jr nz, exx_ret
   
   inc d

exx_ret:

   exx
   ret
