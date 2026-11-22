;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_gt

EXTERN l_long_cmp

l_long_gt:

   ; PRIMARY > SECONDARY? [signed], carry if true
   ; HL set to 0 (false) or 1 (true)

   call l_long_cmp
   jr z, false

   ccf
   ret c

false:

   dec l
   ret
