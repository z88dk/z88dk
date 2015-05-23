
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dpush

cm48_sccz80p_dpush:

   ; sccz80 float primitive
   ; Push float in AC' onto the stack.
   ;
   ; Float is in math48 format.
   ;
   ; enter : AC'   = double (math48 format)
   ;         stack = return
   ;
   ; exit  : stack = double (math48 format)
   ;
   ; uses  : HL
   
   pop hl
   
   exx
   
   push bc
   push de
   push hl
   
   exx
   
   jp (hl)
