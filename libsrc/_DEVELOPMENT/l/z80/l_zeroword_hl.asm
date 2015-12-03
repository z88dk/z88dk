
SECTION code_clib
SECTION code_l

PUBLIC l_zeroword_hl

   inc hl
   inc hl

   inc hl
   inc hl
   
l_zeroword_hl:

   ; Common operation to zero word at offset from hl
   ;
   ; enter : hl = void *address
   ;
   ; exit  : hl = void *address
   ;         *address = 0
   ;
   ; uses  : none
   
   ld (hl),0
   inc hl
   ld (hl),0
   dec hl
   
   ret
