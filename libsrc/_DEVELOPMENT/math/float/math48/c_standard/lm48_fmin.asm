
; double fmin(double x, double y)

SECTION code_fp_math48

PUBLIC lm48_fmin

EXTERN mm48_cmp

lm48_fmin:

   ; return min of double x, double y
   ;
   ; enter : AC (BCDEHL)  = double x
   ;         AC'(BCDEHL') = double y
   ;
   ; exit  : AC'(BCDEHL') = min(x,y)
   ;         AC (BCDEHL ) = max(x,y)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   call mm48_cmp
   ret nc                      ; if x >= y
   exx                         ; swap(x,y)
   ret
