
SECTION code_clib
SECTION code_l

PUBLIC l_minu_de_hl

l_minu_de_hl:

   ; return unsigned minimum of de and hl
   ;
   ; enter : hl = unsigned 16 bit number
   ;         de = unsigned 16 bit number
   ;
   ; exit  : hl = smaller of the two unsigned numbers
   ;         de = unchanged
   ;         carry set if hl was smaller, z flag set if equal
   ;
   ; uses  : af, hl

   ld a,h
   cp d
   ret c
   
   jr nz, de_smaller
   
   ld a,l
   cp e
   ret c

de_smaller:

   ld l,e
   ld h,d

   ret
