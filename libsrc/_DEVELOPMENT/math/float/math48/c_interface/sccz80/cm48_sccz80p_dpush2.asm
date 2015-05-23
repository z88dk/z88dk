
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dpush2

cm48_sccz80p_dpush2:

   ; sccz80 float primitive
   ; Push float in AC' onto stack underneath one stacked word
   ;
   ; Float is in math48 format.
   ;
   ; enter : AC'   = double (math48 format)
   ;         stack = word, return
   ;
   ; exit  : stack = double (math48 format), word
   ;
   ; uses  : DE, HL

   pop hl                      ; hl = return address
   pop de                      ; de = stacked word
   
   exx
   
   push bc
   push de
   push hl
   
   exx
   
   push de
   jp (hl)
