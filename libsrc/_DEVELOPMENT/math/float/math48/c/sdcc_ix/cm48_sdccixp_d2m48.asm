
SECTION code_fp_math48

PUBLIC cm48_sdccixp_d2m48, cm48_sdccixp_dx2m48

cm48_sdccixp_dx2m48:

   ; DEHL = sdcc_float

   ex de,hl

cm48_sdccixp_d2m48:

   ; convert sdcc_float to math48 float
   ;
   ; enter : HLDE = sdcc_float
   ;
   ; exit  : AC' = math48 float
   ;         (exx set is swapped)
   ;
   ; uses  : f, bc, de, hl, bc', de', hl'

   add hl,hl
   rr l
   
   ld c,d
   ld d,e
   ld b,l
   ld l,h
   
   ld e,0
   ld h,e
   
   exx
   ret
