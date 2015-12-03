
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dldpsh

cm48_sccz80p_dldpsh:

   ; sccz80 float primitive
   ; Push float pointed to by HL onto stack.
   ;
   ; enter : HL = double * (sccz80 format)
   ;
   ; exit  : stack  = double (sccz80 format)
   ;
   ; uses  : a, bc, de, hl, ix

   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hldebc = six bytes sccz80 float

   pop ix

   push hl
   push de
   push bc
   
   jp (ix)
