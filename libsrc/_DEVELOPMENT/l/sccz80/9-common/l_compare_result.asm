SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_compare_result

l_compare_result:

   ; return hl=1 if carry set, hl=0 otherwise
   
   ld hl,0
   ret nc
   inc hl    ; do not disturb z flag
   ret
