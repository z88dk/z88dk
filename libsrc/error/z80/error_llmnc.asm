
SECTION code_clib
SECTION code_error

IF !__CPU_INTEL__ && !__CPU_GBZ80__
PUBLIC error_llmnc

EXTERN error_lmnc

   pop hl

error_llmnc:

   ; set dehl'dehl = -1
   ; reset carry flag

   exx
   call error_lmnc
   exx
   jp error_lmnc
ENDIF
