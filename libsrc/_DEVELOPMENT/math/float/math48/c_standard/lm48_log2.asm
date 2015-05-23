
; double log2(double x)

SECTION code_fp_math48

PUBLIC lm48_log2

EXTERN mm48_ln, mm48_fpmul, mm48__add10

lm48_log2:

   ; compute base-2 logarithm of x
   ;
   ; enter : AC'(BCDEHL') = double x
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL') = log2(x)
   ;            carry reset
   ;
   ;         fail on domain error
   ;
   ;            AC'(BCDEHL') = double_min or double_max
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de' hl'
   
   call mm48_ln
   ret c

   push bc
   push de
   push hl
   
   ld bc,$38aa
   ld de,$3b29
   ld hl,$5c81                 ; 1/ln2
   
   call mm48_fpmul
   jp mm48__add10 + 1
