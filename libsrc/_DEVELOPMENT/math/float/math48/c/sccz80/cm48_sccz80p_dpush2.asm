
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dpush2

EXTERN am48_dpushw

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

defc cm48_sccz80p_dpush2 = am48_dpushw
