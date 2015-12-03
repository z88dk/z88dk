
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__ac1

mm48__ac1:

   ; set AC = 1

   ld bc,$0000
   ld de,$0000
   ld hl,$0081
   
   ret
