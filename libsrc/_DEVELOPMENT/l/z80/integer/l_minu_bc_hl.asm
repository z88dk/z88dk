
PUBLIC l_minu_bc_hl

l_minu_bc_hl:

   ; return unsigned minimum of bc and hl
   ;
   ; enter : hl = unsigned 16 bit number
   ;         bc = unsigned 16 bit number
   ;
   ; exit  : hl = smaller of the two unsigned numbers
   ;         bc = unchanged
   ;         carry set if hl was smaller
   ;
   ; uses  : af, hl

   ld a,h
   cp b
   ret c
   
   jr nz, bc_smaller
   
   ld a,l
   cp c
   ret c

bc_smaller:

   ld l,c
   ld h,b

   ret
