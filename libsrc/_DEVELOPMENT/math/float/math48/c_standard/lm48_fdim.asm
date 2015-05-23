
; double fdim(double x, double y)

SECTION code_fp_math48

PUBLIC lm48_fdim

EXTERN mm48_cmp, mm48_fpsub, mm48__retzero

lm48_fdim:

   ; return the positive difference between x and y
   ;
   ; if x >  y return x - y
   ; if x <= y return 0
   ;
   ; enter : AC (BCDEHL ) = double y
   ;         AC'(BCDEHL') = double x
   ;
   ; exit  : success
   ; 
   ;           AC'(BCDEHL')  = fdim(x,y)
   ;           carry reset
   ;
   ;         fail if overflow
   ;
   ;           AC'(BCDEHL')  = double_max
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'
   
   call mm48_cmp

   jp c, mm48_fpsub            ; if x > y return x - y
   exx
   jp mm48__retzero            ; else return 0
