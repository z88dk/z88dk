
; float __uint2fs (unsigned int ui)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_uint2ds

EXTERN am48_double16u, cm48_sdccixp_m482d

cm48_sdccixp_uint2ds:

   ; unsigned int to double
   ;
   ; enter : stack = unsigned int ui, ret
   ;
   ; exit  : dehl = sdcc_float(ui)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   pop af
   pop hl
   
   push hl
   push af

   call am48_double16u
   
   jp cm48_sdccixp_m482d
