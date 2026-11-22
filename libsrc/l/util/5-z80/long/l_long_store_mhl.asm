
SECTION code_clib
SECTION code_l

PUBLIC l_long_store_mhl

l_long_store_mhl:

   ; store long to address in hl
   ;
   ; enter : debc = long
   ;
   ; exit  : *hl  = debc
   ;          hl += 3
   ;
   ; uses  : hl
   
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
   
   ret
