
SECTION code_clib
SECTION code_l

PUBLIC l_readword_2_hl
   
   inc hl
   inc hl
   
   inc hl
   inc hl
   
   inc hl
   inc hl
   
   inc hl
   inc hl

l_readword_2_hl:

   ; Common operation to read a word at offset from hl
   ; then divide by 2
   ;
   ; enter : hl = void *address
   ;
   ; exit  : hl = *hl
   ;
   ; uses  : af, hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   
   srl h
   rra
   
   ld l,a
   
   ret
