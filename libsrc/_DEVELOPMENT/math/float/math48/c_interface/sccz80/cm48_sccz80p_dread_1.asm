
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dread_1

cm48_sccz80p_dread_1:

   ; read float from address in HL
   ;
   ; enter : hl = double * (math48 format)
   ;
   ; exit  : AC' = double
   ;
   ; uses  : af, bc, de, hl, EXX set active
   
   ld bc,5
   add hl,bc
   
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
