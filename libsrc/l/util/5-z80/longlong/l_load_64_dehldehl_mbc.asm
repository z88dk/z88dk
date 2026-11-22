
SECTION code_clib
SECTION code_l

PUBLIC l_load_64_dehldehl_mbc

l_load_64_dehldehl_mbc:

   ; load 64-bit number into dehl'dehl from address bc
   ;
   ; enter : bc = src address
   ;
   ; exit  : bc = src address + 8
   ;         dehl'dehl = 64-bit number
   ;
   ; uses  : a, bc, de, hl, bc', de', hl'

   call again

again:

   ld a,(bc)
   inc bc
   ld l,a
   
   ld a,(bc)
   inc bc
   ld h,a
   
   ld a,(bc)
   inc bc
   ld e,a
   
   ld a,(bc)
   inc bc
   ld d,a
   
   push bc
   exx
   pop bc
   
   ret
