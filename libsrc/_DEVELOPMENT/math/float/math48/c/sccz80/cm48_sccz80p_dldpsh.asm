
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dldpsh

cm48_sccz80p_dldpsh:

   ; sccz80 float primitive
   ; Push float pointed to by HL onto stack.
   ;
   ; Convert from sccz80 float format to math48 float format.
   ;
   ; enter : HL = double * (sccz80 format)
   ;
   ; exit  : AC     = double (math48 format)
   ;         stack  = double (math48 format)
   ;
   ; uses  : A, BC, DE, HL, IX

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

   pop ix
   
   push bc
   push de
   push hl
   
   jp (ix)
