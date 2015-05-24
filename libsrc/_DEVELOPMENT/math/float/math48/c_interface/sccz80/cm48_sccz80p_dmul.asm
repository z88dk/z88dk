
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dmul

EXTERN lm48_mul

cm48_sccz80p_dmul:

   ; sccz80 float primitive
   ; Multiply two math48 floats.
   ;
   ; enter : AC'(BCDEHL') = double x
   ;              stack   = double y, ret
   ;
   ; exit  : AC'(BCDEHL') = x * y
   ;
   ; uses  : AF, BC, DE, HL, AF', BC', DE', HL'
   
   pop af
   
   pop hl                      ; AC = y
   pop bc
   pop de

   push af
   
   jp lm48_mul
