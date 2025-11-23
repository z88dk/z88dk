
; double log2(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_log2

EXTERN am48_log, am48_dmul, am48_dpopret

am48_log2:

   ; compute base-2 logarithm of AC'
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = log2(x)
   ;            carry reset
   ;
   ;         fail on domain error
   ;
   ;            AC' = +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de' hl'
   
   call am48_log
   ret c

   push bc
   push de
   push hl
   
   ld bc,$38aa
   ld de,$3b29
   ld hl,$5c81                 ; 1/ln2
   
   call am48_dmul
   
   jp am48_dpopret
