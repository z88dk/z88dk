
SECTION code_clib
SECTION code_fp_math32

PUBLIC mlib2d

EXTERN error_lznc

   ; convert math48 double to sdcc_float
   ;
   ; enter : AC' = math48 double
   ;
   ; exit  : DEHL = sdcc_float
   ;         (exx set is swapped)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ; TODO FIX THIS. atof is producing something, and I'm not sure what this has to manage.
   
.mlib2d
   exx

   ; alternate entry after exx

   push af

   ld a,l
   sub 2
   jr c, zero
      
   sla b
   rra
   rr b
   
   ld e,b
   ld h,c
   ld l,d
   ld d,a
   
   pop af
   ret

zero:

   call error_lznc
   
   pop af
   ret
