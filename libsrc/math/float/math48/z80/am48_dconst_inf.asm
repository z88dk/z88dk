
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dconst_inf, am48_dconst_pinf, am48_dconst_minf

am48_dconst_inf:

   ; set AC = +-inf depending on sign
   
   bit 7,b
   jr nz, am48_dconst_minf

am48_dconst_pinf:

   ; set AC = +inf
   
   ld bc,$7fff

join:

   ld e,c
   ld d,c
   ld h,c
   ld l,c

   ret

am48_dconst_minf:

   ; set AC = -inf
   
   ld bc,$ffff
   jr join
