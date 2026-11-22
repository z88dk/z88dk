
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dmulpow10

EXTERN mm48_tenf

   ; multiply AC' by a power of ten
   ; AC' *= 10^(A)
   ;
   ; enter : AC'= double x
   ;          A = signed char
   ;
   ; exit  : success
   ;
   ;            AC'= x * 10^(A)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'= +-inf
   ;            carry set, errno set
   ;
   ; note  : current implementation may limit power of ten
   ;         to max one-sided range (eg +-38)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   defc am48_dmulpow10 = mm48_tenf
