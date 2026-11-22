
SECTION code_clib
SECTION code_l

PUBLIC l_readword_hl

   inc hl
   inc hl

   inc hl
   inc hl

   inc hl
   inc hl
   
   inc hl
   inc hl

l_readword_hl:

   ; Common operation to read a word at offset from hl
   ;
   ; enter : hl = void *address
   ;
   ; exit  : hl = *hl
   ;
   ; uses  : a, hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   ret
