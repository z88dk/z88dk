
; double logb(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_logb

EXTERN am48_ilogb, am48_double16, am48_derror_erange_minfc

am48_logb:

   ; Return the power of two exponent of x with significand of x >= 1 and < 2 as double.
   ; This is a logarithm as opposed to lm48_frexp which disassembles the internal exponent of x.
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = logb(x)
   ;            carry reset
   ;
   ;         fail if x == 0
   ;
   ;            AC' = -inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   call am48_ilogb
   jp nc, am48_double16
   
   jp am48_derror_erange_minfc
