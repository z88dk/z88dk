
; float __ulong2fs (unsigned long ul)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_ulong2ds

EXTERN am48_double32u, cm48_sdccixp_m482d

cm48_sdccixp_ulong2ds:

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
   
   push de
   push hl
   push af

   call am48_double32u
   
   jp cm48_sdccixp_m482d
