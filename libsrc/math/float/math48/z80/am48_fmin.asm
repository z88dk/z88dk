
; double fmin(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_fmin

EXTERN am48_dcmp

am48_fmin:

   ; return min of double x, double y
   ;
   ; enter : AC  = double x
   ;         AC' = double y
   ;
   ; exit  : AC' = min(x,y)
   ;         AC  = max(x,y)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   call am48_dcmp
   ret nc                      ; if AC >= AC'
   
   exx                         ; swap(x,y)
   ret
