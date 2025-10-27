;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_ge

EXTERN l_long_cmp

l_long_ge:

   ; PRIMARY >= SECONDARY [signed], carry if true
   ; logical operations: HL set to 0 (false) or 1 (true)

   call l_long_cmp
   
   ccf
   ret c
   
   scf
   ret z
   
   dec l
   ccf
   ret
