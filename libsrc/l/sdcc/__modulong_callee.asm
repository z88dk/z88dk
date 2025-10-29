
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l_sdcc

PUBLIC __modulong_callee

EXTERN l_divu_32_32x32

__modulong_callee:

   ; unsigned 32-bit mod
   ;
   ; enter : stack = divisor (32-bit), dividend (32-bit), ret
   ;
   ; exit  : dehl = remainder
   ;         dehl'= quotient
   
   pop af
   exx
   pop hl
   pop de                      ; dehl' = dividend
   exx
   pop hl
   pop de                      ; dehl  = divisor
   push af

IF (__CLIB_OPT_IMATH <= 50) || (__SDCC_IY)

   call l_divu_32_32x32

   exx
   ret

ENDIF

IF (__CLIB_OPT_IMATH > 50) && (__SDCC_IX)

   push ix
   
   call l_divu_32_32x32
   
   pop ix
   
   exx
   ret

ENDIF
