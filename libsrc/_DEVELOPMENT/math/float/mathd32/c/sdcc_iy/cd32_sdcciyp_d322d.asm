
SECTION code_clib
SECTION code_fp_d32

PUBLIC cm48_sdcciyp_d322d

.cm48_sdcciyp_d322d

   ; convert math48 double to sdcc float
   ;
   ; enter : BCDE = d32 float
   ;
   ; exit  : HLDE = sdcc float
   ;
   ; uses  : bc, de, hl

   ld l,c
   ld h,b

   add hl,hl            ; put sign into Carry
   dec h                ; adjust bias from 127 (IEEE) to 126 (sdcc)
   rr h                 ; return sign from Carry
   rr l

   ret
