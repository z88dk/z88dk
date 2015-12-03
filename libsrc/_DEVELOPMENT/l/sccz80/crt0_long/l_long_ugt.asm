;
;       Z88 Small C+ Run Time Library 
;       Long library functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_gt

EXTERN l_long_ucmp

l_long_gt:

   ; PRIMARY > SECONDARY, carry set if true
   ; HL set to 0 (false) or 1 (true)

   ; dehl  = secondary
   ; stack = primary, ret
   
   call l_long_ucmp
   jr z, false
   
   ccf
   ret c

false:

   dec l
   ret
