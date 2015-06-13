
SECTION code_fp_math48

PUBLIC lm48__nan_b

EXTERN lm48__float_error_einval_zc

lm48__nan_b:

   ld a,(hl)
   
   cp '('
   jp nz, lm48__float_error_einval_zc

   inc hl
   
loop:

   ld a,(hl)
   
   or a
   jp z, lm48__float_error_einval_zc
   
   inc hl
   
   cp ')'
   jp z, lm48__float_error_einval_zc
   
   jr loop
