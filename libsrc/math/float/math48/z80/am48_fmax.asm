
; double fmax(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_fmax

EXTERN am48_dcmp

am48_fmax:

   ; return max of double x, double y
   ;
   ; enter : AC  = double x
   ;         AC' = double y
   ;
   ; exit  : AC' = max(x,y)
   ;         AC  = min(x,y)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   call am48_dcmp
   ret c                       ; if AC < AC'
   
   exx                         ; swap(x,y)
   ret
