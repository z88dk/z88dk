
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_dstore

EXTERN cm48_sdccixp_m482d

cm48_sdccixp_dstore:

   ; sdcc float primitive
   ; Store AC' to memory at address HL
   ;
   ; Convert from math48 to sdcc float format.
   ;
   ; enter : HL = float * (sdcc format)
   ;         AC'= double (math48 format)
   ;
   ; exit  : dehl'= sdcc_float
   ;         *hl  = sdcc_float
   ;
   ; uses  : af, bc', de', hl'
   
   push hl
   
   call cm48_sdccixp_m482d
   
   ;  dehl = sdcc_float
   ; stack = float *
   
   ld c,l
   ld b,h
   
   pop hl
   
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
   
   ld l,c
   ld h,b
   
   exx
   ret
