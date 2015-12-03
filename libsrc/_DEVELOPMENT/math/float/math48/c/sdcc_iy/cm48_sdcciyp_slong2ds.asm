
; float __slong2fs (signed long sl)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_slong2ds

EXTERN am48_double32, cm48_sdcciyp_m482d

cm48_sdcciyp_slong2ds:

   ; signed long to double
   ;
   ; enter : stack = signed long sl, ret
   ;
   ; exit  : dehl = sdcc_float(sl)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   call am48_double32
   
   jp cm48_sdcciyp_m482d
