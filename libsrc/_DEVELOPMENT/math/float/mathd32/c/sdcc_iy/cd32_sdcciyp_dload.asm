
SECTION code_clib
SECTION code_fp_d32

PUBLIC cd32_sdcciyp_dload

EXTERN cd32_sdcciyp_d2d32

.cd32_sdcciyp_dload

   ; sdcc float primitive
   ; Load float pointed to by HL into HLDE
   ;
   ; Convert from sdcc_float format to d32 format.
   ;
   ; enter : HL = float * (sdcc_float )
   ;
   ; exit  : HLDE = float (sdcc_float)
   ;
   ; uses  : f, bc, de, hl

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld h,(hl)
   ld l,c                       ; HLDE = sdcc_float
   
   jp cd32_sdcciyp_d2d32
