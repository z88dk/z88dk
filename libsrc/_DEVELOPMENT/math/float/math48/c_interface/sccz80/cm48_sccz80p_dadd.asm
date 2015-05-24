
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dadd

EXTERN lm48_add

cm48_sccz80p_dadd:

   ; sccz80 float primitive
   ; Add two math48 floats.
   ;
   ; enter : AC'(BCDEHL') = double x
   ;              stack   = double y, ret
   ;
   ; exit  : AC'(BCDEHL') = x + y
   ;
   ; uses  : AF, BC, DE, HL, AF', BC', DE', HL'
   
   pop af
   
   pop hl                      ; AC = y
   pop bc
   pop de

   push af
   
   jp lm48_add
