
SECTION code_clib
SECTION code_fp_d32

PUBLIC cd32_sdcciyp_dload

EXTERN cd32_sdcciyp_d2d32

.cd32_sdcciyp_dload

   ; sdcc float primitive
   ; Load float pointed to by HL into BCDE
   ;
   ; Convert from sdcc float format to d32 format.
   ;
   ; enter : HL = float * (sdcc format)
   ;
   ; exit  : HLDE = float (sdcc format)
   ;
   ; uses  : af, de, hl

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hlde = sdcc_float
   
   jp cd32_sdcciyp_d2d32
