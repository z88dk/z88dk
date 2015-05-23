
; double fmax(double x, double y)

SECTION code_fp_math48

PUBLIC lm48_fmax

EXTERN mm48_cmp

lm48_fmax:

   ; return max of double x, double y
   ;
   ; enter : AC (BCDEHL)  = double x
   ;         AC'(BCDEHL') = double y
   ;
   ; exit  : AC'(BCDEHL') = max(x,y)
   ;         AC (BCDEHL ) = min(x,y)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   call mm48_cmp
   ret c                       ; if x < y
   exx                         ; swap(x,y)
   ret
