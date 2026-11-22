
; double fdim(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_fdim

EXTERN am48_dcmp, am48_dsub, am48_derror_znc

am48_fdim:

   ; return the positive difference between AC' and AC
   ;
   ; if AC' >  AC return AC' - AC
   ; if AC' <= AC return 0
   ;
   ; enter : AC  = double y
   ;         AC' = double x
   ;
   ; exit  : success
   ; 
   ;           AC' = fdim(x,y)
   ;           carry reset
   ;
   ;         fail if overflow
   ;
   ;           AC' = +-inf
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'
   
   call am48_dcmp

   jp c, am48_dsub             ; if x > y return x - y
   jp am48_derror_znc
