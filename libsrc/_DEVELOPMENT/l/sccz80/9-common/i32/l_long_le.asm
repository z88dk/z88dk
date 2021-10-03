;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_le

EXTERN l_long_cmp

l_long_le:

   ; PRIMARY <= SECONDARY [signed], carry set if true
   ; HL set to 0 (false) or 1 (true)
   
   call l_long_cmp
   ret c
   
   scf
   ret z
   
   dec l
   
   or a
   ret
