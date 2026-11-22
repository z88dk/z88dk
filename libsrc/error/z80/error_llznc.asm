
SECTION code_clib
SECTION code_error

IF !__CPU_INTEL__ && !__CPU_GBZ80__
PUBLIC error_llznc

EXTERN error_lznc

   pop hl

error_llznc:

   ; set dehl'dehl = 0
   ; reset carry flag

   exx
   call error_lznc
   exx
   jp error_lznc

ENDIF
