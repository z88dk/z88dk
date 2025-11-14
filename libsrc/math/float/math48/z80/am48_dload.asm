
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dload, am48_dloadb

am48_dload:

   ; load double from memory into AC'
   ;
   ; enter : hl = double *
   ;
   ; exit  : AC'= double x (*hl)
   ;         exx set becomes main set
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   ld bc,5
   add hl,bc

am48_dloadb:

   ld b,(hl)
   dec hl
   ld c,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a

   exx
   ret
