
SECTION code_clib
SECTION code_fp_d32

PUBLIC cm48_sdcciyp_d322d

.cm48_sdcciyp_d322d

   ; convert d32_float to sdcc_float
   ;
   ; enter : BCDE = d32_float
   ;
   ; exit  : HLDE = sdcc_float
   ;
   ; uses  : f, bc, de, hl

   ld l,c
   ld h,b

   add hl,hl            ; put sign into Carry
   dec h                ; adjust bias from 127 (IEEE) to 126 (sdcc)
   rr h                 ; return sign from Carry
   rr l

   ret                  ; return HLDE = sdcc_float
