
SECTION code_fp_math48

PUBLIC lm48__tenf

EXTERN mm48_tenf

   ; AC' = AC' * 10^A
   ; multiply by power of ten
   ;
   ; This function is used for ascii <-> double
   ; conversion and in these applications the
   ; base 10 exponent does not have to go higher
   ; than max double allows, which is smaller
   ; than doubles could be multiplied by without
   ; exceeding range.
   ;
   ; enter :   A = power of 10, |A| < 40
   ;         EXX = float x
   ;
   ; exit  : success
   ;
   ;            AC'= AC' * 10^A
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'= double_max or double_min
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

defc lm48__tenf = mm48_tenf
