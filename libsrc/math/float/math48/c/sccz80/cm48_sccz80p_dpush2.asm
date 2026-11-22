
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dpush2

cm48_sccz80p_dpush2:

   ; sccz80 float primitive
   ; Push float in AC' onto stack underneath one stacked word
   ;
   ; enter : AC'   = double (math48)
   ;         stack = word, return
   ;
   ; exit  : stack = double (sccz80), word
   ;
   ; uses  : af, af', ix

   pop ix
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
   jp (ix)
