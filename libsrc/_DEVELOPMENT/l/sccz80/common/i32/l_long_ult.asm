;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_ult

EXTERN l_long_ucmp

l_long_ult:

   ; PRIMARY < SECONDARY, carry set if true
   ;  HL set to 0 (false) or 1 (true)
   
   ; dehl  = secondary
   ; stack = primary, ret
   
   call l_long_ucmp
   ret c
   
   dec l
   ret
