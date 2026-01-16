
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dloadb

cm48_sccz80p_dloadb:

   ; sccz80 float primitive
   ; Load float given pointer in HL pointing to last byte into AC'.
   ;
   ; enter : HL = double * (sccz80 format) + 5 bytes
   ;
   ; exit  : AC'= double (math48 format)
   ;         (exx set is swapped)
   ;
   ; uses  : a, bc, de, hl, bc', de', hl'

   ld a,(hl)
   dec hl
   ld b,(hl)
   dec hl
   ld c,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld h,(hl)
   ld l,a

   exx
   ret
