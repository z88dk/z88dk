
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_ddiv_s

EXTERN am48_ddiv

am48_ddiv_s:

   ; compute AC'/double
   ;
   ; enter :    AC'= double y
   ;         stack = double x, ret
   ;
   ; exit  : AC = double x
   ;
   ;         success
   ;
   ;           AC'= y/x
   ;           carry reset
   ;
   ;         fail if divide by zero
   ;
   ;           AC'= +-inf
   ;           carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   pop af
   
   pop hl
   pop de
   pop bc
   
   push af
   
   jp am48_ddiv
