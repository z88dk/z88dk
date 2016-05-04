
SECTION code_clib
SECTION code_l

PUBLIC l_store_64_dehldehl_mbc

l_store_64_dehldehl_mbc:

   ; store 64-bit number dehl'dehl to address bc
   ;
   ; enter : dehl'dehl = 64-bit number
   ;         bc        = dst address
   ;
   ; exit  : bc        = dst address + 8
   ;
   ; uses  : a, bc, bc'

   call again

again:
   
   ld a,l
   ld (bc),a
   inc bc
   
   ld a,h
   ld (bc),a
   inc bc
   
   ld a,e
   ld (bc),a
   inc bc
   
   ld a,d
   ld (bc),a
   inc bc
   
   push bc
   exx
   pop bc
   
   ret
