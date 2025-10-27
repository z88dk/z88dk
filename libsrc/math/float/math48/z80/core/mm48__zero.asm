
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__zero, mm48__zero_no

mm48__zero:

   xor a

mm48__zero_no:

   ; set AC = 0

   ld l,0
   ld b,l
   ld c,l
   ld d,l
   ld e,l
   ld h,l
   
   ret
