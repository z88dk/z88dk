
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_d2m48, cm48_sdcciyp_dx2m48

cm48_sdcciyp_dx2m48:

   ; DEHL = sdcc_float

   ex de,hl

cm48_sdcciyp_d2m48:

   ; convert sdcc_float to math48 float
   ;
   ; enter : HLDE = sdcc_float
   ;
   ; exit  : AC' = math48 float
   ;         (exx set is swapped)
   ;
   ; uses  : f, bc, de, hl, bc', de', hl'

   ld a,d
   or e
   or h
   or l
   jr z, zero

   add hl,hl
   rr l
   inc h
   inc h

zero:

   ld c,d
   ld d,e
   ld b,l
   ld l,h
   
   ld e,0
   ld h,e
   
   exx
   ret
