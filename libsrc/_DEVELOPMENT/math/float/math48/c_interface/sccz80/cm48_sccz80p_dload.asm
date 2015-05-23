
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dload

cm48_sccz80p_dload:

   ; sccz80 float primitive
   ; Load float pointed to by HL into AC'.
   ;
   ; Convert from sccz80 float format to math48 format.
   ;
   ; enter : HL = double * (sccz80 format)
   ;
   ; exit  : AC'= double (math48 format)
   ;         (exx set is swapped)
   ;
   ; uses  : A, BC, DE, HL, BC', DE', HL'
   
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
