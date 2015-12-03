
SECTION code_clib
SECTION code_l

PUBLIC l_utod_hl

l_utod_hl:

   ; convert unsigned int to signed int, saturate if necessary
   ;
   ; enter : hl = unsigned int
   ;
   ; exit  : hl = int, maximum $7fff
   ;         carry unaffected
   ;
   ; uses  : f, hl
   
   bit 7,h
   ret z
   
   ld hl,$7fff
   ret
