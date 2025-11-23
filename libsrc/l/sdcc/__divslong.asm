
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l_sdcc

PUBLIC __divslong

EXTERN l_divs_32_32x32

__divslong:

   ; signed 32-bit division
   ;
   ; enter : stack = divisor (32-bit), dividend (32-bit), ret
   ;
   ; exit  : dehl = quotient
   ;         dehl'= remainder
   
   pop af
   exx
   pop hl
   pop de                      ; dehl' = dividend
   exx
   pop hl
   pop de                      ; dehl  = divisor
   
   push de
   push hl
   push de
   push hl
   push af

IF (__CLIB_OPT_IMATH <= 50) || (__SDCC_IY)

   jp l_divs_32_32x32

ENDIF

IF (__CLIB_OPT_IMATH > 50) && (__SDCC_IX)

   push ix
   
   call l_divs_32_32x32
   
   pop ix
   ret

ENDIF
