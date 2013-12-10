
XLIB l_minu_bc_hl
LIB l_exx_bc_hl

l_minu_bc_hl:

   ; return unsigned minimum of bc and hl
   ;
   ; enter : hl = unsigned 16 bit number
   ;         bc = unsigned 16 bit number
   ;
   ; exit  : hl = smaller of the two unsigned numbers
   ;         bc = larger of the two unsigned numbers
   ;
   ; uses  : af, hl

   ld a,h
   cp b
   ret c
   
   jp nz, l_exx_bc_hl
   
   ld a,l
   cp c
   ret c

   jp l_exx_bc_hl
