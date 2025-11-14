
; double fma(double x, double y, double z)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_fma

EXTERN am48_dmul, am48_dadd

am48_fma:

   ; compute x*y+z
   ;
   ; enter : AC  = double x
   ;         AC' = double y
   ;         stack = double z, return address
   ;
   ; exit  : AC  = double z
   ;
   ;         success
   ;
   ;            AC' = x*y+z
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   call am48_dmul              ; AC'= x * y

   ex af,af'
   pop af
   
   pop hl
   pop de
   pop bc
   
   push af
   ex af,af'
   
   jp nc, am48_dadd
   ret
