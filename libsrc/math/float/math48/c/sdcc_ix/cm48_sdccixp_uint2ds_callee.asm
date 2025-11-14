
; float __uint2fs_callee(unsigned int ui)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_uint2ds_callee

EXTERN am48_double16u, cm48_sdccixp_m482d

cm48_sdccixp_uint2ds_callee:

   ; unsigned int to double
   ;
   ; enter : stack = unsigned int ui, ret
   ;
   ; exit  : dehl = sdcc_float(ui)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   pop af
   pop hl
   push af

   call am48_double16u
   
   jp cm48_sdccixp_m482d
