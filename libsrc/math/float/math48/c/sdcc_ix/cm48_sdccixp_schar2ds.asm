
; float __schar2fs (signed char sc)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_schar2ds

EXTERN am48_double8, cm48_sdccixp_m482d

cm48_sdccixp_schar2ds:

   ; signed char to double
   ;
   ; enter : stack = signed char sc, ret
   ;
   ; exit  : dehl = sdcc_float(sc)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   pop af
   pop hl
   
   push hl
   push af

   call am48_double8
   
   jp cm48_sdccixp_m482d
