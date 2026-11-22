
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__acln2

mm48__acln2:

   ; set AC = ln(2)

   ld bc,$3172
   ld de,$17F7
   ld hl,$D280
   
   ret
