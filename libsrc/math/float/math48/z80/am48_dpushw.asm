
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dpushw

am48_dpushw:

   ; push AC' underneath word on stack
   ;
   ; enter : AC'   = double x
   ;         stack = word, ret
   ;
   ; exit  : stack = double x, word
   ;
   ; uses : de, hl
   
   pop hl
   pop de
   
   exx
      
   push bc
   push de
   push hl
   
   exx
   
   push de
   jp (hl)
