
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dmul_s

EXTERN am48_dmul

am48_dmul_s:

   ; Multiply double on stack with double in AC'
   ;
   ; enter :   AC' = double x
   ;         stack = double y, ret
   ;
   ; exit  : AC = double y
   ;
   ;         success
   ;
   ;           AC'= x*y
   ;           carry reset
   ;
   ;         fail if overflow
   ;
   ;           AC'= +-inf
   ;           carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   pop af
   
   pop hl                      ; AC = y
   pop de
   pop bc

   push af
   
   jp am48_dmul
