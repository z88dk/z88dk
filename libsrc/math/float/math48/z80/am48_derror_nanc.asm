
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_nanc

EXTERN am48_derror_einval_zc

   ; set AC'=nan
   ; math48 does not support nan so error is indicated
   
   ; exit : AC'= 0
   ;        carry set, errno set
   ;
   ; uses : af, bc', de', hl'
   
defc am48_derror_nanc = am48_derror_einval_zc
