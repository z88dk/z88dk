
SECTION code_clib
SECTION code_l

PUBLIC l_long_load_mhl

l_long_load_mhl:

   ; read long from address in hl
   ;
   ; enter : hl = long *
   ;
   ; exit  : dehl = long at that address
   ;
   ; uses  : a, de, hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   ex de,hl
   ret
