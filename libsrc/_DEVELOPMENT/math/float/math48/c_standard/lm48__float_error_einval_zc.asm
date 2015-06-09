
SECTION code_fp_math48

PUBLIC lm48__float_error_einval_zc

EXTERN mm48__retzero, error_einval_zc

lm48__float_error_einval_zc:

   ; exit : AC'= 0.0
   ;        carry set, errno = EINVAL
   ;
   ; uses : f, bc', de', hl'
   
   exx

   call error_einval_zc
   call mm48__retzero
   
   scf
   ret
