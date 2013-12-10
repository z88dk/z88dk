
XLIB l_exx_bc_hl

l_exx_bc_hl:

   ; ex bc,hl
   ;
   ; enter : bc = num1
   ;         hl = num2
   ;
   ; exit  : bc = num2
   ;         hl = num1
   ;
   ; uses  : a, bc, hl
   
   ld a,c
   ld c,l
   ld l,a
   
   ld a,b
   ld b,h
   ld h,a
   
   ret
