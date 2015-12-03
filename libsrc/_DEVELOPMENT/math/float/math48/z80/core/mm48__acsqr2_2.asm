
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__acsqr2_2

mm48__acsqr2_2:

   ; set AC = sqr(2)/2

   ld bc,$3504
   ld de,$F333
   ld hl,$FB80

   ret
