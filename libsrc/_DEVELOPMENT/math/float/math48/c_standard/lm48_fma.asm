
; double fma(double x, double y, double z)

SECTION code_fp_math48

PUBLIC lm48_fma

EXTERN mm48_fpmul, mm48__add10, mm48_fpadd

lm48_fma:

   ; compute x*y+z
   ;
   ; enter : AC (BCDEHL ) = double x
   ;         AC'(BCDEHL') = double y
   ;         stack = double z (bcdehl), return address
   ;
   ; exit  : AC (BCDEHL ) = double z
   ;
   ;         success
   ;
   ;            AC'(BCDEHL') = x*y+z
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'(BCDEHL') = double_max or double_min
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   call mm48_fpmul             ; AC'= x * y

   ex af,af'
   pop af
   
   pop hl                      ; AC = z
   pop de
   pop bc
   
   push af
   ex af,af'
   
   jp nc, mm48_fpadd           ; if no overflow   
   ret
