
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dpush

EXTERN am48_dpush

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
   ; uses  : AF

defc cm48_sccz80p_dpush = am48_dpush
