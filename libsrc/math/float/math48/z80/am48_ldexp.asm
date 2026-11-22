
; double ldexp(double x, int exp)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_ldexp

EXTERN am48_dmulpow2

   ; multiply AC' by power of two
   ;
   ; enter : AC' = double x
   ;         HL  = signed integer
   ;
   ; exit  : success
   ;
   ;            AC' = x * 2^(HL)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc', de', hl'

defc am48_ldexp = am48_dmulpow2
