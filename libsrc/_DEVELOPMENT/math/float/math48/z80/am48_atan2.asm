
; double atan2(double y, double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_atan2

EXTERN am48_dcmpa, am48_ddiv, am48_atan, am48_dneg
EXTERN am48_dconst_pi, am48_dadd, am48_dpopret

am48_atan2:

   ; compute arctan y/x in the interval [-pi, +pi] radians
   ;
   ; enter : AC = double y
   ;         AC'= double x
   ;
   ; exit  : AC' = atan2(y,x)
   ;         carry reset
   ;
   ; uses  : af, af', bc', de', hl'

   push bc                     ; save AC
   push de
   push hl
   
   exx
   call am48_dcmpa             ; fabs(x) >= fabs(y) ? (eff |x| - |y|)
   exx
   
   jr nc, greater_equal

less:

   ; AC = y
   ; AC'= x
   
   call am48_ddiv
   call am48_atan
   call am48_dneg              ; AC'= -atan(x/y)
   
   ld a,b
   and $80                     ; a = sgn(y)
   
   call am48_dconst_pi
   dec l                       ; AC = pi/2

join:

   or b
   ld b,a                      ; AC = sgn(y)*pi/2
   
   call am48_dadd
   jp am48_dpopret

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
   
   call am48_ddiv
   call am48_atan              ; AC'= atan(y/x)

   pop af                      ; a = sgn(y)
      
   bit 7,b
   jp z, am48_dpopret          ; if x >= 0 done

   call am48_dconst_pi         ; AC = pi
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
