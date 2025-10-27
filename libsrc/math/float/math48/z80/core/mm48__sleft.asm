
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__sleft, mm48__left

mm48__sleft:

   ;rotate AC left

   or a

mm48__left:

   rl h
   rl e
   rl d
   rl c
   rl b
   
   ret
