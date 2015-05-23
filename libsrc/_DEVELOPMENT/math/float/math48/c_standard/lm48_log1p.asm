
; double log1p(double x)

SECTION code_fp_math48

PUBLIC lm48_log1p

EXTERN mm48__ac1, mm48_fpadd, mm48_ln, mm48__add10

lm48_log1p:

   ; compute ln(x+1)
   ; supposed to be more accurate than ln(x+1) for small |x| (not here)
   ;
   ; enter : AC'(BCDEHL') = double x
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL') = ln(x+1)
   ;            carry reset
   ;
   ;         fail on domain error
   ;
   ;            AC'(BCDEHL') = double_min
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'
   
   push bc                     ; save AC
   push de
   push hl
   
   call mm48__ac1
   call mm48_fpadd
   call mm48_ln
   
   jp mm48__add10 + 1
