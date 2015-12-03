
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_dload

EXTERN cm48_sdcciyp_d2m48

cm48_sdcciyp_dload:

   ; sdcc float primitive
   ; Load float pointed to by HL into AC'
   ;
   ; Convert from sdcc float format to math48 format.
   ;
   ; enter : HL = float * (sdcc format)
   ;
   ; exit  : AC'= double (math48 format)
   ;         (exx set is swapped)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hlde = sdcc_float
   
   jp cm48_sdcciyp_d2m48
