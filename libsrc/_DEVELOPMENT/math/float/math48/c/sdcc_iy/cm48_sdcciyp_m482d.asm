
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_m482d

EXTERN error_lznc

cm48_sdcciyp_m482d:

   ; convert math48 double to sdcc_float
   ;
   ; enter : AC' = math48 double
   ;
   ; exit  : DEHL = sdcc_float
   ;         (exx set is swapped)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   exx

   ; alternate entry after exx

   push af

   ld a,l
   or a
   jr z, zero
   
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
