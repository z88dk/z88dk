
SECTION code_fp_math48

PUBLIC lm48__float_error_nannc

EXTERN lm48__float_error_einval_zc

   pop hl
   pop hl

lm48__float_error_nannc:

   ; exit : AC'= 0.0
   ;        carry set, errno = EINVAL
   ;
   ; uses : f, bc', de', hl'
   
   jp lm48__float_error_einval_zc
