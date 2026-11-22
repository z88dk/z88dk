
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_nan_b

EXTERN am48_derror_einval_zc

am48_nan_b:

   ; strtod() helper function
   ; return nan(...) given pointer to buffer at '('
   ;
   ; enter : hl = char *buff
   ;
   ; exit  : hl = char *buff (moved past nan argument)
   ;         AC'= nan(...)
   ;
   ; note  : math48 does not support nan
   ;
   ; uses  : af, hl, bc', de', hl'

   ld a,(hl)
   
   cp '('
   jp nz, am48_derror_einval_zc

   inc hl
   
loop:

   ld a,(hl)
   
   or a
   jp z, am48_derror_einval_zc
   
   inc hl
   
   cp ')'
   jp z, am48_derror_einval_zc
   
   jr loop
