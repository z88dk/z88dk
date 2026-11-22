
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_nannc

EXTERN am48_derror_nanc

   ; set AC'=nan
   ; math48 does not support nan so error is indicated
   
   ; exit : AC'= 0
   ;        carry set, errno set
   ;
   ; uses : af, bc', de', hl'
   
defc am48_derror_nannc = am48_derror_nanc
