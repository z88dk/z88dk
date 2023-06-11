
SECTION code_clib
SECTION code_l

PUBLIC l_utod_de

l_utod_de:

   ; convert unsigned int to signed int, saturate if necessary
   ;
   ; enter : de = unsigned int
   ;
   ; exit  : de = int, maximum $7fff
   ;         carry unaffected
   ;
   ; uses  : f, de, a (8080)

   ld a,d
   rla
   ret NC

   ld de,$7fff
   ret
