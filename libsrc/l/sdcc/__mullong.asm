
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l_sdcc

PUBLIC __mullong

EXTERN l_mulu_32_32x32

__mullong:

   ; multiply two 32-bit multiplicands into a 32-bit product
   ;
   ; enter : stack = multiplicand (32-bit), multiplicand (32-bit), ret
   ;
   ; exit  : dehl = product
   
   pop af
   exx
   pop hl
   pop de                      ; dehl = multiplicand
   exx 
   pop hl
   pop de                      ; dehl = multiplicand
   
   push de
   push hl
   push de
   push hl
   push af
   
IF (__CLIB_OPT_IMATH <= 50) || (__SDCC_IY)

   jp l_mulu_32_32x32

ENDIF

IF (__CLIB_OPT_IMATH > 50) && (__SDCC_IX)

   push ix
   
   call l_mulu_32_32x32
   
   pop ix
   ret

ENDIF
