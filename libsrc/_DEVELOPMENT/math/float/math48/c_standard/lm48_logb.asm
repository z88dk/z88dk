
; double logb(double x)

SECTION code_fp_math48

PUBLIC lm48_logb

EXTERN lm48_ilogb, mm48_float, mm48_error_erange_minfc

lm48_logb:

   ; Return the power of two exponent of x with significand of x >= 1 and < 2 as float.
   ; This is a logarithm as opposed to lm48_frexp which disassembles the internal exponent of x.
   ;
   ; enter : AC'(BCDEHL') = double x
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL') = logb(x)
   ;            carry reset
   ;
   ;         fail if x == 0
   ;
   ;            AC'(BCDEHL') = double_min
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   call lm48_ilogb
   jp nc, mm48_float
   
   jp mm48_error_erange_minfc
