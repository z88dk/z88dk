
; float __ulong2fs_callee(unsigned long ul)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_ulong2ds_callee

EXTERN am48_double32u, cm48_sdcciyp_m482d

cm48_sdcciyp_ulong2ds_callee:

   ; unsigned long to double
   ;
   ; enter : stack = unsigned long ul, ret
   ;
   ; exit  : dehl = sdcc_float(ul)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   pop af
   pop hl
   pop de
   push af

   call am48_double32u
   
   jp cm48_sdcciyp_m482d
