
SECTION code_clib
SECTION code_l

PUBLIC l_cpl_64_dehldehl
   
l_cpl_64_dehldehl:

   ; complement dehl'dehl
   ;
   ; enter : dehl'dehl = longlong
   ;
   ; exit  : dehl'dehl = complement longlong
   ;
   ; uses  : af, de, hl, de', hl', carry unaffected

   call again
   
again:

   ld a,l
   cpl
   ld l,a
   
   ld a,h
   cpl
   ld h,a
   
   ld a,e
   cpl
   ld e,a
   
   ld a,d
   cpl
   ld d,a
   
   exx
   ret
