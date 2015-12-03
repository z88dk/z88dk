
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double8

EXTERN am48_double16

am48_double8:

   ; 8-bit integer to double
   ;
   ; enter :  L = 8-bit integer n
   ;
   ; exit  : AC = AC' (AC' saved)
   ;         AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   ld a,l                      ; sign extend L into HL
   add a,a
   sbc a,a
   ld h,a
   
   jp am48_double16
