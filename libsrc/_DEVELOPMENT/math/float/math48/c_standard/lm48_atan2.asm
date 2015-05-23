
; double atan2(double y, double x)

SECTION code_fp_math48

PUBLIC lm48_atan2

EXTERN mm48__acpi, mm48__cmp2, mm48__add10
EXTERN mm48_fpdiv, mm48_negate, mm48_atn, mm48_fpadd

lm48_atan2:

   ; compute arctan y/x in the interval [-pi, +pi] radians
   ;
   ; enter : AC (BCDEHL ) = double y
   ;         AC'(BCDEHL') = double x
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL) = atan2(y,x)
   ;            carry reset
   ;
   ;         fail if domain error
   ;
   ;            AC'(BCDEHL) = 0
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   push bc                     ; save AC
   push de
   push hl

   push bc
   res 7,b                     ; y = |y|
   
   exx
   
   push bc
   res 7,b                     ; x = |x|
   
   ; AC = |x|
   ; AC'= |y|
   
   call mm48__cmp2             ; fabs(x) >= fabs(y) ?
   
   pop bc
   exx
   pop bc
   
   ; AC = y
   ; AC'= x
   
   jr nc, greater_equal

less:

   ; AC = y
   ; AC'= x
   
   call mm48_fpdiv             ; AC'= -atan(x/y)
   call mm48_atn
   exx
   call mm48_negate
   exx
   
   ld a,b
   and $80                     ; a = sgn(y)
   
   call mm48__acpi
   dec l                       ; AC = pi/2

join:

   or b
   ld b,a                      ; AC = sgn(y)*pi/2
   
   call mm48_fpadd
   jp mm48__add10 + 1

greater_equal:

   ; AC = y
   ; AC'= x

   ld a,b
   and $80
   push af                     ; save sgn(y)

   exx
   
   ; AC = x
   ; AC'= y
   ; stack = sgn(y)
   
   call mm48_fpdiv             ; AC'= atan(y/x)
   call mm48_atn

   pop af                      ; a = sgn(y)
   
   bit 7,b
   jp z, mm48__add10 + 1       ; if x >= 0 done
   
   call mm48__acpi             ; AC = pi
   jr join

;double atan2(double y, double x)
;{
;   double a;
;
;   if (fabs(x) >= fabs(y))
;   {
;      a = atan(y/x);
;      if (x < 0.0)
;      {
;         if (y >= 0.0)
;            a += _pi ;
;         else a -= _pi ;
;       }
;   }
;   else
;   {
;      a = -atan(x/y);
;      if (y < 0.0)
;         a -= _halfpi;
;      else
;         a += _halfpi;
;   }
;
;   return a;
;}
