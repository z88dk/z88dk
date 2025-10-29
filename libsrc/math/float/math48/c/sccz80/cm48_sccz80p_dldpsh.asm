
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dldpsh

EXTERN cm48_sccz80p_dload, cm48_sccz80p_dpush

cm48_sccz80p_dldpsh:

   ; sccz80 float primitive
   ; Push float pointed to by HL onto stack.
   ;
   ; enter : HL = double * (sccz80 format)
   ;
   ; exit  : AC'    = double (math48 format)
   ;         stack  = double (sccz80 format)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix

   call cm48_sccz80p_dload
	jp cm48_sccz80p_dpush
