
; double nan(const char *tagp)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_nan

EXTERN am48_derror_einval_zc

   ; return nan
   ;
   ; enter : hl = char *tagp
   ;
   ; exit  : AC' = 0
   ;         carry set, errno set
   ;
   ; note  : math48 does not support nan
   ;
   ; uses  : af, bc', de', hl'

defc am48_nan = am48_derror_einval_zc
