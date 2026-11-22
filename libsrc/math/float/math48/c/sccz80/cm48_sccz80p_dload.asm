
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dload

   exx

cm48_sccz80p_dload:

   ; sccz80 float primitive
   ; Load float pointed to by HL into AC'.
   ;
   ; enter : HL = double * (sccz80 format)
   ;
   ; exit  : AC'= double (math48 format)
   ;         (exx set is swapped)
   ;
   ; uses  : a, bc, de, hl, bc', de', hl'

   ld a,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld l,(hl)
   ld h,a

   exx
   ret
