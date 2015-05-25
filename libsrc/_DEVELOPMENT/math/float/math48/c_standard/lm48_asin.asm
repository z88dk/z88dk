
; double asin(double x)

SECTION code_fp_math48

PUBLIC lm48_asin

EXTERN mm48_equal, mm48_fpmul, mm48__ac1, mm48_fpadd
EXTERN mm48_sqr, mm48_fpdiv, mm48_atn, mm48__add10

lm48_asin:

   ; arcsin
   ; AC' = asin(AC')
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : success
   ;
   ;            AC' = asin(x)
   ;            carry reset
   ;
   ;         fail if domain error |x| > 1
   ;
   ;            AC' = 0
   ;            carry set, errno set
   ;
   ; note  : -pi/2 < asin(x) < pi/2
   ;
   ; uses  : af, af', bc', de', hl'
   
   ; asin(x) = atan(x/sqrt(1-x*x))
   
   push bc                     ; save AC
   push de
   push hl
   
   exx
   
   push bc                     ; save x
   push de
   push hl
   
   call mm48_equal             ; AC = AC'= x
   call mm48_fpmul             ; AC'= x*x
   call mm48__ac1              ; AC = 1
   
   exx
   
   set 7,b                     ; AC = -x*x
   call mm48_fpadd             ; AC'= 1-x*x
   
   call mm48_sqr
   
   pop hl                      ; AC = x
   pop de
   pop bc
   
   jp c, mm48__add10 + 1       ; if domain error
   
   exx
   
   call mm48_fpdiv             ; AC'= x/sqrt(1-x*x)
   call mm48_atn
   
   jp mm48__add10 + 1
