SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dpush3

cm48_sccz80p_dpush3:

   ; sccz80 float primitive
   ; Push float in AC' onto stack underneath one stacked long
   ;
   ; enter : AC'   = double (math48)
   ;         stack = long, return
   ;
   ; exit  : stack = double (sccz80), long
   ;
   ; uses  : af, af', hl, ix

   pop ix
   pop hl
   pop af
   
   exx
   ex af,af'
   
   ld a,l
   push af
   inc sp
   push bc
   push de
   push hl
   inc sp

   ex af,af'
   exx
   
   push af
   push hl
   
   jp (ix)
