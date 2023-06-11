
SECTION code_clib
SECTION code_l

PUBLIC l_cpl_64_mhl

l_cpl_64_mhl:

   ; complement 64-bit number at address hl
   ;
   ; enter : hl = longlong *
   ;
   ; exit  : *longlong = ~longlong
   ;
   ; uses  : af, hl, carry unaffected

   call again

again:

   ld a,(hl)
   cpl
   ld (hl),a
   inc hl

   ld a,(hl)
   cpl
   ld (hl),a
   inc hl

   ld a,(hl)
   cpl
   ld (hl),a
   inc hl

   ld a,(hl)
   cpl
   ld (hl),a
   inc hl

   ret
