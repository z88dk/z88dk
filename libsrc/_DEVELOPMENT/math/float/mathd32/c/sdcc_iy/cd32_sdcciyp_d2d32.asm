
SECTION code_clib
SECTION code_fp_d32

PUBLIC cd32_sdcciyp_d2d32

.cd32_sdcciyp_d2d32

   ; convert sdcc_float to d32_float
   ;
   ; enter : HLDE = sdcc_float
   ;
   ; exit  : BCDE = d32_float
   ;
   ; uses  : f, bc, de, hl

;   add hl,hl            ; put sign into Carry
;   inc h                ; adjust bias from 126 (sdcc) to 127 (IEEE)
;   rr h                 ; return sign from Carry
;   rr l

   ld c,l
   ld b,h

   ret                  ; return BCDE = d32_float
